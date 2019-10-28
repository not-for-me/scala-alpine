FROM jwj0831/scala-alpine

# Install common dev tools
RUN apk add --no-cache curl git zsh neovim maven \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install fzy deps.
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache fzy@testing ripgrep@testing

# Build metals-vim
RUN curl -L -o coursier https://git.io/coursier \
    && chmod +x coursier \
    && ./coursier bootstrap \
        --java-opt -Xss4m \
        --java-opt -Xms100m \
        --java-opt -Dmetals.client=coc.nvim \
        org.scalameta:metals_2.12:0.7.6 \
        -r bintray:scalacenter/releases \
        -r sonatype:snapshots \
        -o /usr/local/bin/metals-vim -f \
    && ln -s /usr/local/bin/metals-vim /usr/bin/

# Set up extra dev tools
RUN apk add --no-cache yarn \
    && curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && mkdir -p /root/.config/nvim

COPY ./init.vim /root/.config/nvim/init.vim
COPY ./coc-settings.json /root/.config/nvim/coc-settings.json
COPY ./dev_sources/spark /spark

ENV MAVEN_OPTS="-Xmx4g -XX:ReservedCodeCacheSize=1g"

ENTRYPOINT ["/bin/zsh"]