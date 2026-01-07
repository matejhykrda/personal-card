# Osobní vizitka (ukázka)

Tento malý projekt obsahuje jednoduchou webovou stránku sloužící jako osobní vizitka.

Soubory:

- `index.html` — hlavní stránka vizitky
- `styles.css` — jednoduché styly

Jak publikovat na GitHub Pages

1. Vytvořte nový repozitář na GitHubu (např. `personal-card`) a nastavte výchozí branch na `main`.
2. V lokálním adresáři projektu spusťte (přizpůsobte podle vašeho uživatelského jména a repozitáře):

```bash
git init
git branch -M main
git add .
git commit -m "Initial personal card"
git remote add origin https://github.com/VAŠE_UŽIVATELSKÉ_JMÉNO/personal-card.git
git push -u origin main
```

3. Na GitHubu otevřete repozitář → Settings → Pages. V sekci Source vyberte branch `main` (kořenový adresář) a uložte.
4. Po chvilce bude stránka dostupná na `https://VAŠE_UŽIVATELSKÉ_JMÉNO.github.io/personal-card/`.

Nápověda

- Můžete upravit `index.html` a `styles.css` a znovu commitovat a pushovat změny.
- Pro předběžné lokální náhledy stačí otevřít `index.html` v prohlížeči.

Poznámka: Nepoužívejte skutečné osobní údaje, pokud nechcete, aby byly veřejné.