# Instruções para o agente de IA

Este repositório gera **um currículo sob medida para cada vaga**. O usuário cola a
descrição de uma vaga; você produz um CV em PDF, otimizado para passar no filtro
automático (ATS) e convencer o recrutador humano, sem inventar nada.

Vale para Claude Code, Codex, GitHub Copilot, Cursor, Gemini CLI ou qualquer agente
que leia este arquivo. Responda no idioma do usuário (padrão: português).

## Estrutura

```
base/
  perfil.md        # FONTE DA VERDADE: tudo que é verdade sobre a pessoa
  modelo.br.tex    # modelo LaTeX em português
  modelo.en.tex    # modelo LaTeX em inglês
  preamble.tex     # estilo compartilhado. NUNCA copiar para as vagas
vagas/
  <empresa-cargo>/
    vaga.md        # descrição da vaga colada + checklist de requisitos
    cv.md          # rascunho do CV adaptado, em Markdown (revisão humana)
    cv.br.tex      # (ou cv.en.tex) versão final em LaTeX
    cv.br.pdf      # PDF gerado
build.sh           # Linux/macOS: ./build.sh vagas/<slug>/cv.br.tex
build.ps1          # Windows (PowerShell): .\build.ps1 vagas\<slug>\cv.br.tex
build.cmd          # Windows (cmd ou duplo clique): build.cmd vagas\<slug>\cv.br.tex
```

`<empresa-cargo>` é kebab-case, sem acento: `nubank-analista-dados`, `itau-dev-java-sr`.
A pasta `vagas/exemplo-empresa-analista-dados/` mostra um ciclo completo; use como referência.

## Compatibilidade com Windows

O usuário pode estar no Windows. Antes de rodar comandos, descubra o sistema
(o ambiente costuma informar; na dúvida, `$env:OS` no PowerShell retorna `Windows_NT`).

- **Prefira suas ferramentas de arquivo** (criar, ler, editar arquivos) a comandos de
  shell para criar pastas e copiar arquivos. Assim funciona igual em qualquer sistema.
- Para gerar o PDF:
  - Windows: `.\build.ps1 vagas\<slug>\cv.br.tex` (ou `build.cmd ...` se a política de
    execução bloquear scripts).
  - Linux/macOS: `./build.sh vagas/<slug>/cv.br.tex`.
- Se o shell do Windows for PowerShell, não use `cp`, `mkdir -p`, `&&` encadeado com
  sintaxe bash, `grep`, `sed`. Equivalentes: `Copy-Item`, `New-Item -ItemType Directory -Force`,
  `Select-String`. Ou simplesmente use as ferramentas de arquivo.
- Se `pdflatex` não existir: oriente a instalar o MiKTeX (`winget install MiKTeX.MiKTeX`,
  depois reabrir o terminal e rodar `initexmf --set-config-value=[MPM]AutoInstall=1`).
  Alternativa sem instalar nada: subir `base/preamble.tex` + o `cv.*.tex` no Overleaf
  (overleaf.com) e compilar lá. Ver README.

## Passo zero: o perfil está preenchido?

Antes de qualquer vaga, abra `base/perfil.md`. Se ainda for a pessoa fictícia
**Ana Souza** (ou estiver vazio), pare e faça o onboarding:

1. Peça ao usuário o currículo atual (PDF, Word, texto), o texto do LinkedIn, ou
   simplesmente que conte a trajetória.
2. Preencha `base/perfil.md` mantendo as seções. Registre **números reais** (quantos,
   quanto, em quanto tempo) e pergunte por eles quando faltarem: "quantos clientes?",
   "reduziu quanto?". Números são o que mais diferencia um CV.
3. Preencha "Coisas que NÃO sei". Isso protege contra invenção.
4. Atualize também cabeçalho, nome e `\newcommand{\cvnome}{...}` em `base/modelo.br.tex`
   e `base/modelo.en.tex`, e o conteúdo do modelo com a versão "geral" do CV.
5. Gere o PDF do modelo e mostre ao usuário para validar.

Só depois disso siga para vagas.

## Fluxo para uma vaga nova

O usuário cola a vaga (texto ou link; se for link e você não conseguir abrir, peça o texto).

1. **Pasta:** crie `vagas/<empresa-cargo>/`.
2. **vaga.md:** salve a descrição **literal** e depois uma seção `## Notas` com:
   - empresa, cargo, senioridade, modelo (remoto/híbrido/presencial), idioma do CV;
   - checklist `- [ ]` de **todos** os requisitos obrigatórios, ferramentas exigidas e
     palavras que se repetem no anúncio, usando os termos exatos da vaga.
3. **Idioma:** vaga brasileira em português → `cv.br.tex`. Vaga internacional ou
   escrita em inglês → `cv.en.tex`. Pergunte só se for ambíguo.
4. **cv.md (rascunho em Markdown):** a partir de `base/perfil.md`, escreva o CV
   adaptado à vaga (regras abaixo). É o ponto de revisão: fácil de ler e corrigir.
   Mostre um resumo ao usuário e pergunte se quer ajustar algo antes do LaTeX, a menos
   que ele tenha pedido para ir direto.
5. **Cobertura:** percorra o checklist do `vaga.md` e marque `- [x]` cada requisito que
   aparece no `cv.md` (termo exato ou sinônimo exato). Requisito sem lugar honesto no
   perfil fica `- [ ]` e entra numa lista **Lacunas**. Nunca invente para preencher.
6. **cv.<idioma>.tex:** copie `base/modelo.<idioma>.tex` para a pasta da vaga e troque
   o conteúdo pelo do `cv.md`. Mantenha a estrutura de ambientes (`header`, `onecolentry`,
   `twocolentry`, `highlights`) e a linha `\input{preamble.tex}`.
   Escape caracteres especiais do LaTeX: `%` → `\%`, `&` → `\&`, `$` → `\$`, `#` → `\#`,
   `_` → `\_`. Acentos podem ficar como estão (UTF-8).
7. **PDF:** rode o build. Se falhar, leia o log, corrija o `.tex` e rode de novo.
8. **Tamanho:** o build informa o número de páginas. Meta: **1 página** para até ~5 anos
   de experiência, **até 2 páginas** acima disso. Nunca termine com uma 2ª página quase
   vazia (ou enxugue frases, ou complete com conteúdo real do perfil).
9. **Relatório final ao usuário:**
   - decisões de adaptação (o que subiu, o que foi reescrito, o que ficou de fora e por quê);
   - mapa requisito → onde aparece no CV;
   - **Lacunas** (requisitos não cobertos) com sugestão honesta: estudar, citar na
     entrevista, ou ignorar se for "desejável";
   - caminho completo do PDF;
   - próxima ação: onde se candidatar e uma mensagem curta de apresentação pronta para
     colar (LinkedIn, e-mail ou WhatsApp do recrutador, conforme a vaga indicar).

## Doutrina de adaptação

O CV tem dois leitores, e os dois precisam aprovar:

1. **ATS / filtro automático:** compara palavras-chave. Os termos exatos da vaga
   precisam estar no CV, senão a candidatura é descartada sem ninguém ler.
2. **Recrutador humano:** fareja exagero e enrolação. Tudo precisa ser plausível,
   conciso e defensável numa entrevista.

**Pode:**
- Reescrever o **resumo** para abrir com o que a vaga mais valoriza.
- Reordenar **competências** para as palavras da vaga aparecerem primeiro.
- Reordenar bullets dentro de um emprego, promovendo o que casa com a vaga.
- **Espelhar o vocabulário** da vaga: mesmo fato, palavra deles
  ("gestão de stakeholders" em vez de "conversar com áreas"; "ETL" em vez de "carga de dados").
- Encaixar uma ferramenta exigida num emprego real **onde ela plausivelmente foi usada**
  e está no perfil (ex.: o perfil diz que usou Azure Data Factory na Loja Exemplo →
  pode aparecer no bullet de automação de cargas).
- Escolher quais projetos mostrar e mudar a ordem das seções.

**Não pode:**
- Inventar empresa, cargo, data, diploma, certificação ou número.
- Afirmar ferramenta ou experiência que não esteja em `base/perfil.md` ou que esteja em
  "Coisas que NÃO sei". Se faltar, é **Lacuna**, não mentira. Em caso de dúvida,
  pergunte ao usuário ("você já usou Tableau?") e, se a resposta for sim, adicione
  ao `perfil.md` primeiro.
- Alterar contato, formação ou números das conquistas.
- Encher linguiça: nada de "proativo, dinâmico, apaixonado por desafios".
- Copiar o `preamble.tex` para a pasta da vaga.
- Usar tabelas, colunas laterais, imagens ou foto: atrapalham o ATS.

**Estilo dos bullets:** verbo de ação ou resultado no início, com número quando houver.
"Reduzi o fechamento mensal de 5 para 2 dias automatizando cargas com Python" é melhor
que "Responsável por automações".

## Informação nova durante a conversa

Se o usuário contar algo novo e verdadeiro (um curso, um número, uma ferramenta),
adicione em `base/perfil.md` primeiro, para valer nas próximas vagas também.

## Pretensão salarial

Só informe se a vaga pedir. Sempre em faixa (ex.: "R$ 7.000 a R$ 9.000"), nunca valor
único, usando a faixa do `perfil.md` e ajustando ao nível da vaga.
