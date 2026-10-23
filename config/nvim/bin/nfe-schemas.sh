#!/usr/bin/env bash
# Baixa os esquemas XML "em uso" do portal da NF-e para ~/Core/schemas/nfe, usados por lua/utils/nfe_xml.lua.
# Fonte: https://www.nfe.fazenda.gov.br/portal/listaConteudo.aspx?tipoConteudo=BMPFMBoln3w=
# Para atualizar um pacote, troque o código `conteudo` do link "exibirArquivo.aspx?conteudo=<código>".
set -euo pipefail

DESTINO="${NFE_SCHEMAS_DIR:-$HOME/Core/schemas/nfe}"
PORTAL="https://www.nfe.fazenda.gov.br/portal"

# pasta|conteudo|zip interno (opcional)|título
# Pacotes não se misturam: cada um traz a sua própria versão de tiposBasico.
# Em eventos/, o prefixo de data decide qual pacote vence quando dois trazem o mesmo e<tpEvento>.
PACOTES=$(
	cat <<'EOF'
nfe|8ITFuBLltXs=||Pacote de Liberação 010f (NT 2025.002 v1.50 e NT 2026.007) - 31/08/2026
cons|+pBOYTXBtbk=||Pacote de Liberação 010d v1.03 (CNPJ alfanumérico) - 10/07/2026
evento|FOEnx2KAsCk=|PL_Evento.zip|Eventos genéricos com CNPJ alfanumérico (010d v1.01) - 08/06/2026
cadastro|FOEnx2KAsCk=|CadConsultaCadastro_NT2026.004.zip|Consulta Cadastro (NT 2026.004) - 08/06/2026
distdfe|IzuP2y0G6hk=||Distribuição de DF-e v1.04 - 03/07/2026
gtin|xJdTH687/8s=||Consulta GTIN (NT 2022.001) - 31/05/2022
eventos/2026-07-27_rtc|kp0SXLu+ZdI=||Eventos da NT 2025.002 v1.40 (RTC) - 27/07/2026
eventos/2025-04-30_averbacao|G3fIxJUvAD8=||Evento de Averbação v1.01 - 30/04/2025
eventos/2024-07-30_conciliacao|tL1S8quJtVE=||Evento de Conciliação Financeira - 30/07/2024
eventos/2024-04-26_insucesso|qvyq5vuft74=||Evento Insucesso na Entrega - 26/04/2024
eventos/2021-06-15_comprovante|W9sYeScSDZg=||Evento Comprovante de Entrega - 15/06/2021
eventos/2021-01-28_ator|Y1hrcyzvncE=||Evento Ator Interessado - 28/01/2021
eventos/2018-12-21_canc_subst|6UBZKIOo6qU=||Evento Cancelamento por Substituição (NFC-e) - 21/12/2018
eventos/2018-12-21_canc|0Yynu2Ck+bM=||Evento Cancelamento - 21/12/2018
eventos/2015-11-27_prorrog|KSNIzTeJ4mY=||Evento Prorrogação Industrialização - 27/11/2015
eventos/2015-11-25_suframa_vistoria|QuYuRVqPWuQ=||Evento Suframa Vistoria v1.01 - 25/11/2015
eventos/2015-01-26_suframa_internaliza|D8VcRXDh9xk=||Evento Suframa Internaliza v1.01 - 26/01/2015
eventos/2014-05-30_canc|Ig8Y9i6kgOc=||Evento Cancelamento v1.01 - 30/05/2014
eventos/2014-05-30_cce|+0MSTVshMl8=||Evento CC-e v1.01 - 30/05/2014
eventos/2014-05-30_epec|OPt9hJUGOv0=||Evento EPEC v1.01 - 30/05/2014
eventos/2014-05-30_manifesta|Q7x6aqhBAy4=||Evento Manifestação do Destinatário v1.01 - 30/05/2014
EOF
)

NS='xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.portalfiscal.inf.br/nfe" targetNamespace="http://www.portalfiscal.inf.br/nfe" elementFormDefault="qualified"'

trabalho=$(mktemp -d)
trap 'rm -rf "$trabalho"' EXIT
novo="$trabalho/nfe"
cookies="$trabalho/cookies.txt"

baixar() {
	local conteudo=$1 arquivo="$trabalho/zip_${1//[^A-Za-z0-9]/_}.zip"
	if [[ ! -f $arquivo ]]; then
		# O portal só responde depois de gravar o cookie AspxAutoDetectCookieSupport; sem cookie jar ele redireciona em loop.
		curl -sSL --max-redirs 20 -c "$cookies" -b "$cookies" -A "Mozilla/5.0" \
			"$PORTAL/exibirArquivo.aspx?conteudo=${conteudo//+/%2B}" -o "$arquivo"
		file -b "$arquivo" | grep -q '^Zip' || return 1
	fi
	echo "$arquivo"
}

# Extrai os .xsd sem a estrutura de pastas; o zip interno, quando informado, é aberto antes.
extrair() {
	local zip=$1 interno=$2 pasta=$3
	if [[ -n $interno ]]; then
		unzip -p "$zip" "$interno" >"$trabalho/interno.zip"
		zip="$trabalho/interno.zip"
	fi
	mkdir -p "$pasta"
	unzip -qjo "$zip" '*.xsd' -d "$pasta"
	# Os pacotes trazem nomes fora do padrão (ex.: "e112120_v1.00 .xsd" e "110150_v1.00.xsd" sem o "e").
	for f in "$pasta"/*' '*.xsd; do [[ -e $f ]] && mv "$f" "${f// /}"; done
	for f in "$pasta"/[0-9]*_v*.xsd; do [[ -e $f ]] && cp "$f" "$pasta/e${f##*/}"; done
	return 0
}

falhas=0
while IFS='|' read -r pasta conteudo interno titulo; do
	if zip=$(baixar "$conteudo") && extrair "$zip" "$interno" "$novo/$pasta"; then
		printf 'ok     %-40s %s\n' "$pasta" "$titulo"
		printf '%s\t%s\n' "$pasta" "$titulo" >>"$novo/VERSAO"
	else
		printf 'FALHOU %-40s %s (o portal não devolveu um zip: confira o código %s)\n' "$pasta" "$titulo" "$conteudo" >&2
		falhas=$((falhas + 1))
	fi
done <<<"$PACOTES"

if ((falhas)); then
	echo "$falhas pacote(s) falharam; $DESTINO não foi alterado." >&2
	exit 1
fi

# Os pacotes oficiais não declaram esses elementos raiz.
printf '<xs:schema %s><xs:include schemaLocation="leiauteNFe_v4.00.xsd"/><xs:element name="nfeProc" type="TNfeProc"/></xs:schema>\n' "$NS" \
	>"$novo/nfe/procNFe_v4.00.xsd"
printf '<xs:schema %s><xs:include schemaLocation="leiauteEvento_v1.00.xsd"/><xs:element name="evento" type="TEvento"/></xs:schema>\n' "$NS" \
	>"$novo/evento/evento_v1.00.xsd"
sed -i "1i baixado em $(date '+%d/%m/%Y %H:%M')" "$novo/VERSAO"

if [[ -d $DESTINO ]]; then
	rm -rf "$DESTINO.anterior"
	mv "$DESTINO" "$DESTINO.anterior"
fi
mkdir -p "$(dirname "$DESTINO")"
mv "$novo" "$DESTINO"
echo "Esquemas instalados em $DESTINO (versão anterior em $DESTINO.anterior)."
