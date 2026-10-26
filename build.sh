#!/usr/bin/env bash
# Gera o PDF de um curriculo .tex (o PDF fica ao lado do .tex).
# Uso: ./build.sh vagas/<empresa-cargo>/cv.br.tex
#      ./build.sh base/modelo.br.tex
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

src="${1:?uso: ./build.sh caminho/para/cv.tex}"
[ -f "$src" ] || { echo "arquivo nao encontrado: $src" >&2; exit 1; }
command -v pdflatex >/dev/null || {
  echo "pdflatex nao encontrado. Instale o TeX Live (Linux: apt install texlive-full; macOS: brew install --cask mactex)." >&2
  exit 1
}
src="$(cd "$(dirname "$src")" && pwd)/$(basename "$src")"
dir="$(dirname "$src")"
name="$(basename "${src%.tex}")"

# Deixa o preamble.tex visivel a partir de qualquer pasta de vaga.
export TEXINPUTS="${ROOT}/base:${dir}:${TEXINPUTS:-}"

aux="${dir}/.aux-build"
mkdir -p "$aux"

# lastpage precisa de duas passadas para o "Pagina X de Y".
for pass in 1 2; do
  pdflatex -interaction=nonstopmode -halt-on-error \
    -output-directory "$aux" "$src" >/dev/null || {
      echo "pdflatex falhou (passada $pass). Final do log:" >&2
      tail -30 "${aux}/${name}.log" >&2
      exit 1
    }
done

mv "${aux}/${name}.pdf" "${dir}/${name}.pdf"
pages="$(sed -n 's/.*(\([0-9]*\) pages\{0,1\},.*/\1/p' "${aux}/${name}.log" | tail -1)"
echo "pronto: ${dir}/${name}.pdf${pages:+ (${pages} pagina(s))}"
