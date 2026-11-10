# Projeto #10: Rastreador de Hábitos (Habit Tracker)

- **Modalidade:** Projeto Oficial Sorteado (Valendo 100 pontos)
- **Estudante:** Lorenzzo Oliveira Figueiredo de Freitas
- **Turma:** 2C
- **Chave Única:** `P26-2C-7195-ACC2-3B49-1AE1`
- **URL_CLOUDFLARE:** `https://p26-2c-7195-acc2-3b49-1ae1.pages.dev` *(Atualize com a URL pública real do seu deploy na Cloudflare antes de abrir o Pull Request)*

---

## Especificação do Projeto

Implemente um painel de acompanhamento de hábitos diários que exibe uma grade matricial representando os dias do mês corrente. Após autenticar-se com o Discord, o usuário pode cadastrar metas recorrentes e marcar caixas de seleção correspondentes aos dias em que cumpriu a atividade, com atualização imediata de barras de progresso em CSS.

Os registros de conclusão (data e ID do hábito) são armazenados no Cloudflare D1 através de endpoints RESTful na Cloudflare. O backend deve processar e retornar métricas consolidadas, como a maior sequência de dias ininterruptos (streak máximo), a sequência atual e a taxa percentual de cumprimento mensal, renderizadas no cliente em formato de indicadores numéricos.

---

## Como Publicar esta Subpasta no Cloudflare Pages + D1 + Discord OAuth2

1. No painel da Cloudflare (**Workers & Pages** → **Create** → **Pages** → **Connect to Git**), selecione o seu fork do repositório `Avalia2026-2`.
2. Configure os parâmetros de build apontando para esta subpasta:
   - **Root directory (Diretório raiz):** `P26-2C-7195-ACC2-3B49-1AE1`
   - **Build command:** *(deixe em branco — HTML/CSS/JS puro)*
   - **Build output directory:** `public`
3. Crie o banco de dados D1 e aplique a migração inicial (no terminal do laboratório usando Scoop):
   ```powershell
   cd P26-2C-7195-ACC2-3B49-1AE1
   npx.cmd wrangler d1 create db-p26-2c-7195-acc2-3b49-1ae1
   # Copie o database_id gerado para o arquivo wrangler.jsonc e execute:
   npx.cmd wrangler d1 migrations apply DB --remote
   ```
4. **Vincule o Banco D1 ao seu Cloudflare Pages (Obrigatório para ativar env.DB):**
   - No painel da Cloudflare: acesse seu projeto Pages → **Settings** → **Functions** → **D1 database bindings**.
   - Clique em **Add binding**:
     - **Variable name:** `DB`
     - **D1 database:** selecione o banco que você criou (`db-p26-2c-7195-acc2-3b49-1ae1`).
5. **Configuração do Discord OAuth2 (Obrigatório para autenticação real):**
   - Acesse o **Discord Developer Portal** (https://discord.com/developers/applications) e crie uma nova Application.
   - Na aba **OAuth2**:
     - Copie o **Client ID** e gere o **Client Secret**.
     - Em **Redirects**, adicione a URL exata do deploy:
       `https://p26-2c-7195-acc2-3b49-1ae1.pages.dev/api/auth/discord/callback`
   - No painel do seu projeto no Cloudflare Pages:
     - Acesse **Settings** → **Environment variables**.
     - Adicione as variáveis de ambiente:
       - `DISCORD_CLIENT_ID`
       - `DISCORD_CLIENT_SECRET`
6. Atualize o campo **URL_CLOUDFLARE** no topo deste `README.md` com o endereço público gerado pela Cloudflare.
7. Na raiz do repositório, execute `node validar-local.mjs P26-2C-7195-ACC2-3B49-1AE1` para validar todos os critérios antes de fazer o commit e abrir o Pull Request.
