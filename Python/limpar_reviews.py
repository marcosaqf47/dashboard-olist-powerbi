import pandas as pd

caminho_original = r'C:\Users\Marcos\Downloads\projeto_olist\Data\olist_order_reviews_dataset.csv'
caminho_limpo = r'C:\Users\Marcos\Downloads\projeto_olist\Data\olist_order_reviews_clean.csv'

# Tenta UTF-8 primeiro; se falhar, usa latin1, que aceita qualquer byte
try:
    df = pd.read_csv(caminho_original, encoding='utf-8')
    print('Lido como UTF-8')
except UnicodeDecodeError:
    df = pd.read_csv(caminho_original, encoding='latin1')
    print('Lido como latin1 (bytes inválidos tolerados)')

print('Linhas lidas:', len(df))
print('Colunas:', list(df.columns))

# Salva uma versão limpa, sempre em UTF-8 válido
df.to_csv(caminho_limpo, index=False, encoding='utf-8')
print('Arquivo limpo salvo em:', caminho_limpo)