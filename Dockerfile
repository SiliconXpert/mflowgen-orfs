# Target with dependencies and the binaries to run the complete flow
# FROM openroad/flow-dev
FROM mflowgen/openroad-flow-scripts-base:2024-0621-f0caba6



WORKDIR /OpenROAD-flow-scripts


# RUN git sparse-checkout init --cone
RUN git clone --no-checkout --depth=1 --filter=blob:none https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git  && \
    cd OpenROAD-flow-scripts && \
    git sparse-checkout set flow && \
    git checkout

RUN rm -rf flow && \
    mv OpenROAD-flow-scripts/flow . && \
    rm -rf OpenROAD-flow-scripts && \
    rm -rf flow/designs/*

    
