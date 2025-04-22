# Crystal公式イメージを使用
FROM crystallang/crystal:latest

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y git curl

# llama.crリポジトリをクローン
RUN git clone --depth 1 https://github.com/kojix2/llama.cr.git /llama.cr

# 作業ディレクトリを移動
WORKDIR /llama.cr

# モデルをダウンロード
RUN chmod +x download_tinyllama.sh && ./download_tinyllama.sh

# 依存関係をインストール
RUN shards install

# サーバー起動
CMD ["crystal", "run", "examples/server.cr"]
