# Currículo por Vaga

Gere um currículo sob medida para cada vaga: você cola o anúncio, uma IA adapta seu
currículo usando só fatos verdadeiros do seu perfil e gera um PDF limpo, legível pelos
filtros automáticos (ATS) das empresas.

```
perfil.md  ──►  vaga colada  ──►  cv.md (rascunho)  ──►  cv.tex  ──►  cv.pdf
(sua verdade)    (vaga.md)        (você revisa)        (LaTeX)      (envia)
```

- **`base/perfil.md`**: tudo que é verdade sobre você, escrito uma vez só.
- **`vagas/<empresa-cargo>/`**: uma pasta por candidatura, com a vaga, o rascunho e o PDF.
- **`AGENTS.md`**: as regras que a IA segue (cobrir as palavras da vaga, nunca inventar).

Veja `vagas/exemplo-empresa-analista-dados/` para um ciclo completo com uma pessoa fictícia.

## Por que um currículo por vaga?

Muitas empresas usam sistemas que filtram currículos por palavra-chave antes de um
humano ler. Se a vaga pede "Power BI" e seu CV diz "ferramentas de BI", você pode ser
descartado. Adaptar cada CV aos termos da vaga aumenta muito a taxa de entrevistas, e
este repositório faz isso sem inventar experiência.

## Instalação no Windows

1. **Git** (para baixar o projeto):
   ```powershell
   winget install Git.Git
   ```
2. **MiKTeX** (transforma o `.tex` em PDF):
   ```powershell
   winget install MiKTeX.MiKTeX
   ```
   Feche e abra o terminal, e permita que ele baixe pacotes sozinho:
   ```powershell
   initexmf --set-config-value=[MPM]AutoInstall=1
   ```
3. **Uma IA de linha de comando** (escolha uma):
   - Claude Code: <https://claude.com/claude-code>
   - Codex CLI (OpenAI), Gemini CLI, ou o Copilot / Cursor dentro do VS Code.
4. **Baixe o projeto:**
   ```powershell
   git clone https://github.com/mateussatoh/curriculo-por-vaga.git
   cd curriculo-por-vaga
   ```
5. **Teste o PDF:**
   ```powershell
   .\build.cmd base\modelo.br.tex
   ```
   Deve aparecer `pronto: ...\base\modelo.br.pdf`.

> Sem vontade de instalar LaTeX? Use o [Overleaf](https://www.overleaf.com) (grátis,
> no navegador): crie um projeto em branco, envie `base/preamble.tex` e o seu `cv.br.tex`,
> e clique em *Recompile*.

### Linux / macOS

Instale o TeX Live (`sudo apt install texlive-full` ou `brew install --cask mactex`) e
use `./build.sh` no lugar de `build.cmd`.

## Como usar

### 1. Primeira vez: preencha seu perfil

Abra a IA na pasta do projeto (por exemplo, `claude` no terminal) e diga:

> Me ajuda a preencher meu perfil. Aqui está meu currículo atual: (cole o texto ou arraste o PDF)

A IA preenche `base/perfil.md`, pergunta pelos números que faltam (quantos clientes,
quanto economizou, em quanto tempo) e atualiza o modelo com seus dados.

**Capriche aqui.** Tudo que o CV pode dizer sai desse arquivo. Inclua também a seção
"Coisas que NÃO sei": ela impede a IA de afirmar o que você não domina.

### 2. Para cada vaga

Cole a vaga e peça:

> Faz meu currículo para esta vaga: (cole o texto do anúncio)

A IA vai:
1. criar `vagas/<empresa-cargo>/vaga.md` com a vaga e um checklist de requisitos;
2. escrever `cv.md`, o rascunho adaptado, e mostrar para você revisar;
3. gerar `cv.br.tex` (ou `cv.en.tex` para vagas em inglês) e o PDF;
4. te dar um relatório: o que mudou, onde cada requisito aparece, e as **lacunas**
   (o que a vaga pede e você não tem, com sugestão do que fazer).

Revise o PDF, envie, e pronto.

### 3. Sem IA de terminal (só ChatGPT, Claude.ai etc.)

Use o arquivo `PROMPT.md`: ele traz um texto pronto para colar no chat junto com seu
perfil e a vaga. A resposta é o `.tex`, que você compila com `build.cmd` ou no Overleaf.

## Gerar o PDF manualmente

| Sistema | Comando |
|---|---|
| Windows (cmd ou PowerShell) | `build.cmd vagas\minha-vaga\cv.br.tex` |
| Windows (PowerShell, scripts liberados) | `.\build.ps1 vagas\minha-vaga\cv.br.tex` |
| Linux / macOS | `./build.sh vagas/minha-vaga/cv.br.tex` |

O PDF aparece ao lado do `.tex`, e o comando informa quantas páginas ele tem.

## Editar o visual

O estilo (fontes, margens, cores) fica todo em `base/preamble.tex`. A cor dos links é
`primaryColor`; as margens estão no bloco `geometry`. Mudou ali, vale para todos os CVs.

## Problemas comuns

| Sintoma | Solução |
|---|---|
| `pdflatex nao encontrado` | Instale o MiKTeX e **reabra o terminal**. |
| `... .sty not found` | Rode `initexmf --set-config-value=[MPM]AutoInstall=1` e tente de novo. |
| "a execução de scripts foi desabilitada" | Use `build.cmd` em vez de `.\build.ps1`. |
| Erro com `%`, `&`, `$`, `#` ou `_` no texto | No `.tex` escreva `\%`, `\&`, `\$`, `\#`, `\_`. |
| Uma 2ª página quase vazia | Enxugue frases ou peça à IA: "cabe em 1 página sem cortar fatos?" |

## Créditos

Estilo baseado no tema *sb2nov* do [RenderCV](https://github.com/rendercv/rendercv).
Licença MIT: use, modifique e compartilhe à vontade.
