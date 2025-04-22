FROM crystallang/crystal:latest

RUN apt-get update && apt-get install -y git curl cmake unzip

RUN git clone --depth 1 https://github.com/kojix2/llama.cr.git /llama.cr

WORKDIR /llama.cr

RUN export LLAMA_VERSION=$(cat LLAMA_VERSION) && \
    curl -L https://github.com/ggml-org/llama.cpp/releases/download/${LLAMA_VERSION}/llama-${LLAMA_VERSION}-bin-ubuntu-x64.zip -o llama.zip && \
    unzip llama.zip && \
    mkdir -p /usr/local/lib && \
    cp build/bin/*.so /usr/local/lib/ && \
    ldconfig

RUN chmod +x ./examples/download_tinyllama.sh && ./examples/download_tinyllama.sh

RUN cd examples && shards build --release

WORKDIR /llama.cr/examples

CMD ["/llama.cr/examples/bin/server", "-m", "/llama.cr/examples/models/tinyllama.gguf"]
