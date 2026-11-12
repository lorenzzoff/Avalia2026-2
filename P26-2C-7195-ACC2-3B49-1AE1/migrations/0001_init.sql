-- Rastreador de Hábitos — esquema inicial (Cloudflare D1 / SQLite)

CREATE TABLE IF NOT EXISTS users (
  id           TEXT PRIMARY KEY,                      -- user_id do Discord (snowflake)
  username     TEXT NOT NULL,
  display_name TEXT,
  avatar       TEXT,                                  -- hash do avatar no CDN do Discord
  created_at   TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at   TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS habits (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id    TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name       TEXT NOT NULL CHECK (length(name) BETWEEN 1 AND 60),
  color      TEXT NOT NULL DEFAULT '#5eead4',
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_habits_user ON habits(user_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_habits_user_name ON habits(user_id, name COLLATE NOCASE);

-- Um registro por (hábito, dia) concluído. A chave primária impede duplicatas.
CREATE TABLE IF NOT EXISTS completions (
  habit_id   INTEGER NOT NULL REFERENCES habits(id) ON DELETE CASCADE,
  date       TEXT NOT NULL CHECK (date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY (habit_id, date)
) WITHOUT ROWID;
