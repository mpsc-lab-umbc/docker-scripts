FROM ufoym/deepo:all-jupyter-py36-cu101

LABEL maintainer="Abu Zaher Md Faridee <zaher14@gmail.com>"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        tree \
        htop \
        less \
        graphviz \
        vim \
        git \
        libxml2 libxml2-dev curl libssl-dev libcurl4-openssl-dev psmisc libedit2 sudo libclang-dev \
        wget && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip --no-cache-dir install \
        graphviz \
        tqdm \
        tensorflow-gpu \
        jupyter_contrib_nbextensions \
        jupyter_nbextensions_configurator \
        jupyterthemes \
        seaborn \
        yapf \
        isort \
        python-crfsuite \
        nltk \
        xgboost \
        tzlocal \
        'plotnine[all]' \
        tsnecuda \
        qgrid \
        seaborn \
        pydot \
        transforms3d \
        tables

RUN jupyter contrib nbextension install --user
RUN jupyter nbextensions_configurator enable --user
RUN jupyter nbextension enable --py --sys-prefix qgrid

RUN mkdir -p /root/.jupyter/nbconfig
RUN echo '{ "load_extensions": { "contrib_nbextensions_help_item/main": true, "runtools/main": true, "nbextensions_configurator/config_menu/main": true, "freeze/main": true, "toggle_all_line_numbers/main": true, "scratchpad/main": true, "spellchecker/main": false, "notify/notify": true, "scroll_down/main": true, "autosavetime/main": true, "toc2/main": true, "execute_time/ExecuteTime": true, "code_prettify/code_prettify": true, "jupyter-js-widgets/extension": true, "qgrid/extension": true }, "scrollDownIsEnabled": true }' > /root/.jupyter/nbconfig/notebook.json
RUN echo '{ "load_extensions": { "nbextensions_configurator/tree_tab/main": true } }' > /root/.jupyter/nbconfig/tree.json

RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN mkdir -p /root/.code-server/extensions

RUN wget https://github.com/microsoft/vscode-python/releases/download/2020.5.86806/ms-python-release.vsix
RUN code-server --install-extension ms-python-release.vsix

RUN mkdir -p /root/.local/share/code-server/User/
COPY settings.json /root/.local/share/code-server/User/

# COPY --from=codercom/code-server:2.1698 /usr/local/bin/code-server /usr/local/bin/code-server
# COPY --from=codercom/code-server:latest /usr/local/lib/code-server /usr/local/lib/code-server 
# RUN ln -s /usr/local/lib/code-server/code-server /usr/local/bin/code-server

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--notebook-dir='/notebooks'"]
