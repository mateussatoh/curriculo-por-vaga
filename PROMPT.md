# Prompt para usar em chat (ChatGPT, Claude.ai, Gemini...)

Para quem não usa IA no terminal. Copie o bloco abaixo, troque as três partes entre
`<<< >>>` e cole no chat. A IA devolve o rascunho, o relatório e o `.tex` pronto.
Salve o `.tex` em `vagas/<empresa-cargo>/` e gere o PDF com `build.cmd` (ou no Overleaf).

````text
Você vai adaptar meu currículo para uma vaga específica. Regras:

1. Use SOMENTE fatos do MEU PERFIL abaixo. Nunca invente empresa, cargo, data,
   diploma, ferramenta ou número. O que a vaga pede e eu não tenho é "lacuna".
2. Os termos exatos da vaga (ferramentas, competências) precisam aparecer no CV
   sempre que forem verdadeiros para mim, porque o currículo passa por filtro de
   palavras-chave (ATS).
3. Reescreva o resumo para abrir com o que a vaga mais valoriza, reordene
   competências e bullets para o que casa com a vaga vir primeiro, e use o
   vocabulário da vaga para descrever os mesmos fatos.
4. Bullets curtos, começando por ação ou resultado, com números quando existirem.
   Nada de "proativo, dinâmico, apaixonado".
5. 1 página se eu tiver até ~5 anos de experiência; no máximo 2 acima disso.

Entregue, nesta ordem:
A) Checklist dos requisitos da vaga, marcando onde cada um aparece no CV.
B) Lacunas: requisitos que eu não cubro, com uma sugestão honesta para cada.
C) O arquivo LaTeX completo, seguindo EXATAMENTE a estrutura do MODELO abaixo
   (mesmos comandos e ambientes, só troque o conteúdo; escape % & $ # _ com \).

=== MEU PERFIL ===
<<< cole aqui o conteúdo de base/perfil.md >>>

=== VAGA ===
<<< cole aqui o texto do anúncio >>>

=== MODELO LATEX ===
<<< cole aqui o conteúdo de base/modelo.br.tex (ou modelo.en.tex para vaga em inglês) >>>
````
