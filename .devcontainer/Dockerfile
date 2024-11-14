FROM rocker/tidyverse

RUN /rocker_scripts/install_python.sh && \
    /rocker_scripts/install_julia.sh

RUN apt-get update && apt-get install -y \
    openssh-client \
    gnupg \
    pipx \
    && rm -rf /var/lib/apt/lists/*

RUN install2.r --error --skipinstalled -n -1 \
    --repos https://manuelhentschel.r-universe.dev --repos getOption \
    renv \
    languageserver \
    httpgd \
    vscDebugger \
    && rm -rf /tmp/downloaded_packages \
    && strip /usr/local/lib/R/site-library/*/libs/*.so

USER rstudio
WORKDIR /home/rstudio

RUN mkdir -p .cache/R/renv .local/lib .cache/pip .julia .local/pipx .local/bin .cache/pydrive2fs && \
    Rscript -e 'tinytex::install_tinytex(force = TRUE)'

RUN python3 -m pip config set global.break-system-packages true && \
    pipx ensurepath && \
    pipx install --include-deps radian && \
    pipx install --include-deps dvc[gdrive]
