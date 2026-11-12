# Agentes, harness e skills

**Projeto #10 — Rastreador de Hábitos** · Chave única: `P26-2C-7195-ACC2-3B49-1AE1`

## Harness

Os agentes operam no **Claude Code** (CLI da Anthropic), que carrega *subagents* definidos em Markdown na pasta `.claude/agents/`. Cada arquivo tem um cabeçalho (nome, descrição, ferramentas permitidas, modelo) e um prompt de sistema próprio. O agente principal delega tarefas a eles pelo nome, e cada subagente trabalha com contexto isolado.

Os **skills** ficam em `skills/<nome>/SKILL.md`. Cada agente tem, no seu prompt, a instrução de ler o skill correspondente antes de agir.

```
.claude/agents/
├── arquiteto-backend.md
├── dev-frontend.md
└── qa-validador.md
skills/
├── serverless-d1-discord/SKILL.md
├── vanilla-dom-ui/SKILL.md
└── teste-validacao/SKILL.md
```

## Os três agentes

| Agente | Papel | Pode escrever em | Skill usado |
|---|---|---|---|
| `arquiteto-backend` | Esquema D1, login Discord OAuth2, endpoints REST, regras de negócio e métricas (streaks, taxa mensal) | `functions/`, `lib/`, `migrations/`, `wrangler.jsonc` | `serverless-d1-discord` |
| `dev-frontend` | Interface em HTML5/CSS3/JS puro: grade mensal, barras de progresso, indicadores, login, responsividade | `public/` | `vanilla-dom-ui` |
| `qa-validador` | **Teste e validação**: roda a suíte, cria testes, audita segurança, confere a rubrica. Não corrige código-fonte, apenas reporta | `tests/` | `teste-validacao` |

### Agente 1 — arquiteto-backend (backend serverless)

Definição: [`.claude/agents/arquiteto-backend.md`](.claude/agents/arquiteto-backend.md) · Skill: [`serverless-d1-discord`](skills/serverless-d1-discord/SKILL.md).
Modela o esquema no D1 por migrations, implementa o login Discord OAuth2 e os endpoints REST, e concentra todas as regras de negócio no servidor (validação, propriedade dos dados, bloqueio de datas futuras, métricas).

### Agente 2 — dev-frontend (interface em Vanilla JS)

Definição: [`.claude/agents/dev-frontend.md`](.claude/agents/dev-frontend.md) · Skill: [`vanilla-dom-ui`](skills/vanilla-dom-ui/SKILL.md).
Constrói a grade mensal, as barras de progresso em CSS, os indicadores numéricos e o login, em HTML5/CSS3/JS puro, consumindo o contrato de API do `README.md`.

### Agente 3 — qa-validador (teste e validação)

Definição: [`.claude/agents/qa-validador.md`](.claude/agents/qa-validador.md) · Skill: [`teste-validacao`](skills/teste-validacao/SKILL.md).
Agente dedicado a **teste e validação**: executa `npm test`, escreve novos testes, audita segurança e confere a rubrica. Não corrige o código-fonte: reporta o defeito ao agente dono.

### Por que essa separação
- Cada agente tem **escopo de escrita restrito**, o que evita que um agente desfaça o trabalho do outro.
- O `qa-validador` não conserta o que testa: ele reporta e o agente dono corrige. Assim quem valida não é quem produziu o código.
- O contrato entre front e back é a seção **API** do `README.md`.

## Fluxo de trabalho

```
arquiteto-backend ──(contrato de API no README)──► dev-frontend
        │                                              │
        └──────────────► qa-validador ◄────────────────┘
                              │
              relatório de defeitos (arquivo, passos, esperado × obtido)
                              │
                 volta ao agente dono → correção → nova validação
```

1. `arquiteto-backend` cria migration, Functions e `lib/`, e documenta o contrato.
2. `dev-frontend` constrói a interface sobre esse contrato.
3. `qa-validador` executa `npm test`, audita e valida; defeitos voltam ao agente dono.
4. Só depois de a suíte passar e o relatório estar limpo é feito o deploy.

## Skills

| Skill | Conteúdo |
|---|---|
| [`serverless-d1-discord`](skills/serverless-d1-discord/SKILL.md) | Roteamento das Pages Functions, uso do D1 (SQL parametrizado, batch, migrations), regras de negócio no servidor, fluxo OAuth2 do Discord, checklist de segurança |
| [`vanilla-dom-ui`](skills/vanilla-dom-ui/SKILL.md) | Regras de DOM sem framework, atualização otimista com o servidor como fonte da verdade, barras de progresso em CSS, acessibilidade, responsividade |
| [`teste-validacao`](skills/teste-validacao/SKILL.md) | Comandos de teste, cobertura da suíte, regras do validador, auditoria de segurança, checklist da rubrica, formato do relatório |

## Como executar os agentes

Na raiz desta pasta, com o Claude Code instalado:

```bash
claude
```

Dentro da sessão, peça a delegação pelo nome do agente, por exemplo:

```text
Use o agente arquiteto-backend para revisar functions/api/habits e confirmar que toda rota valida o dono do hábito.
Use o agente dev-frontend para ajustar a grade para telas de 360px.
Use o agente qa-validador para rodar a suíte e auditar segurança antes do deploy.
```

O comando `/agents` lista os agentes carregados de `.claude/agents/`.

## Registro de execução

> **Preencha esta tabela com as execuções reais feitas por você no Claude Code** (data, agente, pedido, resultado). Não registre execuções que não aconteceram.

| Data | Agente | Pedido resumido | Resultado / achados |
|---|---|---|---|
| | | | |
| | | | |
| | | | |

## Resultado de validação (suíte automatizada)

`npm test` executa 33 testes (`tests/stats.test.mjs` e `tests/api.test.mjs`): 33 passaram, 0 falharam na geração inicial do projeto. Re-execute localmente e registre o resultado atual aqui após cada mudança.
