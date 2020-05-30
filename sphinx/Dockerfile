FROM python

MAINTAINER Jean Traullé

RUN apt-get update                                                              && \
    apt-get install -y --no-install-recommends default-jre-headless graphviz    && \
    apt-get autoremove -y                                                       && \
    rm -rf /var/cache/*                                                         && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip && \
    pip install 'Sphinx                        == 2.4.4' \
                'alabaster                     == 0.7.12' \
                'sphinx_press_theme            == 0.5.1' \
                'sphinx-autobuild              == 0.7.1' \
                'sphinx_bootstrap_theme        == 0.7.1' \
                'sphinx-prompt                 == 1.1.0' \
                'sphinx_rtd_theme              == 0.4.3' \
                'guzzle_sphinx_theme           == 0.7.11' \
                'sphinxcontrib-actdiag         == 2.0.0' \
                'sphinxcontrib-blockdiag       == 2.0.0' \
                'sphinxcontrib-nwdiag          == 2.0.0' \
                'sphinxcontrib-plantuml        == 0.18'   \
                'sphinxcontrib-seqdiag         == 2.0.0' \
                'livereload                    == 2.6.1'

ADD plantuml.jar /opt/plantuml.jar

ENV DOC_DIR /doc

VOLUME $DOC_DIR
WORKDIR $DOC_DIR

EXPOSE 8080

CMD sphinx-autobuild -H 0.0.0.0 -p 8080 /doc /doc/_build/html
