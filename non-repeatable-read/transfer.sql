BEGIN;
UPDATE accounts
SET balance = balance + 100
WHERE id = 1;
UPDATE accounts
SET balance = balance - 100
WHERE id = 2;
COMMIT;