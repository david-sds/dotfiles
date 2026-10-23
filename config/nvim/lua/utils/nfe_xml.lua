-- Valida XMLs da SEFAZ (NF-e, eventos, DF-e, consultas) com xmllint, escolhendo o esquema pela raiz.
-- Esquemas: rodar scripts/nfe-schemas.sh (baixa os pacotes em uso do portal para ~/Core/schemas/nfe).
local M = {}

local SCHEMAS = vim.fn.expand("~/Core/schemas/nfe")
local NS = "http://www.portalfiscal.inf.br/nfe"
local namespace = vim.api.nvim_create_namespace("nfe_xml")

local SCHEMA_POR_RAIZ = {
	NFe = "nfe/nfe_v4.00.xsd",
	nfeProc = "nfe/procNFe_v4.00.xsd",
	envEvento = "evento/envEvento_v1.00.xsd",
	evento = "evento/evento_v1.00.xsd",
	procEventoNFe = "evento/procEventoNFe_v1.00.xsd",
	retEnvEvento = "evento/retEnvEvento_v1.00.xsd",
	consSitNFe = "cons/consSitNFe_v4.00.xsd",
	retConsSitNFe = "cons/retConsSitNFe_v4.00.xsd",
	procInutNFe = "cons/procInutNFe_v4.00.xsd",
	retConsReciNFe = "cons/retConsReciNFe_v4.00.xsd",
	ConsCad = "cadastro/consCad_v2.00.xsd",
	retConsCad = "cadastro/retConsCad_v2.00.xsd",
	distDFeInt = "distdfe/distDFeInt_v1.01.xsd",
	retDistDFeInt = "distdfe/retDistDFeInt_v1.01.xsd",
	resNFe = "distdfe/resNFe_v1.01.xsd",
	resEvento = "distdfe/resEvento_v1.01.xsd",
	consGTIN = "gtin/consGTIN_v1.00.xsd",
	retConsGTIN = "gtin/retConsGTIN_v1.00.xsd",
}

local function linha_de(texto, pos)
	return select(2, texto:sub(1, pos):gsub("\n", "")) + 1
end

-- Esquema da raiz quando ela é da SEFAZ; NFS-e de prefeituras também usam raiz "NFe", em outro namespace.
local function schema_da_raiz(texto)
	local sem_prologo = texto:gsub("<%?.-%?>", ""):gsub("<!%-%-.-%-%->", "")
	local nome, atributos = sem_prologo:match("<([%w_:%.%-]+)([^>]*)>")
	if not nome then
		return nil
	end
	local prefixo, local_name = nome:match("^(.-):(.+)$")
	local xmlns = prefixo and atributos:match("xmlns:" .. prefixo .. '="([^"]*)"') or atributos:match('xmlns="([^"]*)"')
	local relativo = SCHEMA_POR_RAIZ[local_name or nome]
	return xmlns == NS and relativo and SCHEMAS .. "/" .. relativo or nil
end

-- O pacote com a data mais recente no nome da pasta vence quando dois trazem o mesmo tpEvento.
local function schema_do_evento(tp_evento, versao)
	local candidatos = vim.fn.glob(("%s/eventos/*/e%s_v%s.xsd"):format(SCHEMAS, tp_evento, versao), false, true)
	table.sort(candidatos, function(a, b)
		return a > b
	end)
	return candidatos[1]
end

-- O envelope do evento aceita qualquer conteúdo em detEvento: cada um é validado à parte contra e<tpEvento>_v<versao>.xsd.
local function eventos(texto)
	local lista, inicio = {}, 1
	while true do
		local s = texto:find("<detEvento[%s>]", inicio)
		if not s then
			return lista
		end
		local _, fim = texto:find("</detEvento>", s, true)
		if not fim then
			return lista
		end
		local tp_evento
		for tp in texto:sub(1, s):gmatch("<tpEvento>(%d+)</tpEvento>") do
			tp_evento = tp
		end
		local trecho = texto:sub(s, fim)
		local abertura = trecho:match("^<detEvento[^>]*>")
		if not abertura:find("xmlns=", 1, true) then
			trecho = trecho:gsub("^<detEvento", '<detEvento xmlns="' .. NS .. '"', 1)
		end
		table.insert(lista, {
			trecho = trecho,
			linha = linha_de(texto, s),
			tp_evento = tp_evento,
			versao = abertura:match('versao="([^"]+)"'),
		})
		inicio = fim + 1
	end
end

-- Roda o xmllint no `texto` e devolve os diagnósticos deslocados para a `linha` onde o trecho começa no buffer.
local function xmllint(texto, schema, linha, callback)
	local cmd = schema and { "xmllint", "--noout", "--schema", schema, "-" } or { "xmllint", "--noout", "-" }
	vim.system(cmd, { stdin = texto, text = true }, function(resultado)
		local diagnosticos, sintaxe = {}, false
		for l, mensagem in (resultado.stderr or ""):gmatch("%-:(%d+): ([^\n]+)") do
			sintaxe = sintaxe or mensagem:find("parser error", 1, true) ~= nil
			table.insert(diagnosticos, {
				lnum = linha + tonumber(l) - 2,
				col = 0,
				severity = vim.diagnostic.severity.ERROR,
				source = "NF-e schema",
				message = mensagem:gsub("^.-[Ee]rror : ", ""):gsub("{https?://[^}]*}", ""),
			})
		end
		callback(diagnosticos, sintaxe)
	end)
end

function M.lint(bufnr)
	bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
	local tick = vim.api.nvim_buf_get_changedtick(bufnr)
	local texto = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")

	local function publicar(diagnosticos)
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_changedtick(bufnr) == tick then
				vim.diagnostic.set(namespace, bufnr, diagnosticos)
			end
		end)
	end

	local schema = schema_da_raiz(texto)
	if schema and vim.fn.filereadable(schema) == 0 then
		local aviso = "esquema não instalado: rode ~/.config/nvim/scripts/nfe-schemas.sh"
		publicar({ { lnum = 0, col = 0, severity = vim.diagnostic.severity.WARN, source = "NF-e schema", message = aviso } })
		return
	end

	-- vim.fn não pode ser chamado no callback do vim.system: os esquemas dos eventos são resolvidos antes.
	local pendentes = schema and eventos(texto) or {}
	for _, evento in ipairs(pendentes) do
		evento.xsd = evento.tp_evento and evento.versao and schema_do_evento(evento.tp_evento, evento.versao)
	end

	xmllint(texto, schema, 1, function(diagnosticos, sintaxe)
		local restantes = sintaxe and 0 or #pendentes
		if restantes == 0 then
			return publicar(diagnosticos)
		end
		for _, evento in ipairs(pendentes) do
			local xsd = evento.xsd
			local function concluir(extras)
				vim.list_extend(diagnosticos, extras)
				restantes = restantes - 1
				if restantes == 0 then
					publicar(diagnosticos)
				end
			end
			if xsd then
				xmllint(evento.trecho, xsd, evento.linha, concluir)
			else
				concluir({
					{
						lnum = evento.linha - 1,
						col = 0,
						severity = vim.diagnostic.severity.WARN,
						source = "NF-e schema",
						message = ("sem esquema para o evento %s versão %s"):format(evento.tp_evento, evento.versao),
					},
				})
			end
		end
	end)
end

return M
