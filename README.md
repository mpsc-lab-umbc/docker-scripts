A simple script to get you started with ML development within a docker container. It assumes you don't know much about Docker and takes you right into your development environment without breaking a sweat.

# Quickstart
Open the `Makefile` and change the values of the following variables
* `CONTAINER`: Use `azmfaridee/dl` in the image name field if you want to use the pre-built image otherwise, assign your own name for the image and build with `make docker-build` command
* `CONTAINER`: Assign an easily identifiable name for your docker container e.g. `faridee_project1`
* `AVAILABLE_GPUS`: Index starts at `0` and ends at `3`. Use comma separated values if you need more than one gpu, e.g. `AVAILABLE_GPUS=2,3`
* Modify all the port numbers so that there's no conflict with other users
    * `LOCAL_JUPYTER_PORT`
    * `LOCAL_TENSORBOARD_PORT`

To run the docker container for the first time, use the following command:
```
make docker-run
```
You Should see a prompt as following:

```
NV_GPU='0' docker run -it -p 18443:8443 -p 18888:8888 -p \
        16006:6006 -p 18787:8787 -v /home/azmfaridee/Documents/projects/mpsc/docker-scripts:/notebooks --name faridee_project1 azmfaridee/dl
[I 22:32:16.066 NotebookApp] Writing notebook server cookie secret to /root/.local/share/jupyter/runtime/notebook_cookie_secret
[I 22:32:16.259 NotebookApp] [jupyter_nbextensions_configurator] enabled 0.4.1
[I 22:32:16.260 NotebookApp] Serving notebooks from local directory: /notebooks
[I 22:32:16.260 NotebookApp] The Jupyter Notebook is running at:
[I 22:32:16.260 NotebookApp] http://4f588f77a77a:8888/?token=86bc42b488a9737264201b71f279f4226165ddab5749c6f9
[I 22:32:16.260 NotebookApp]  or http://127.0.0.1:8888/?token=86bc42b488a9737264201b71f279f4226165ddab5749c6f9
[I 22:32:16.260 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[W 22:32:16.270 NotebookApp] No web browser found: could not locate runnable browser.
[C 22:32:16.270 NotebookApp]

    To access the notebook, open this file in a browser:
        file:///root/.local/share/jupyter/runtime/nbserver-1-open.html
    Or copy and paste one of these URLs:
        http://4f588f77a77a:8888/?token=86bc42b488a9737264201b71f279f4226165ddab5749c6f9
     or http://127.0.0.1:8888/?token=86bc42b488a9737264201b71f279f4226165ddab5749c6f9
```

Point your browser to the provided url from the prompt and you should be able to access the jupyter notebook.

# Advanced

## Resuming the Container
If you close the prompt and want to re-run the your container again, you'll need to use the following command
```
make docker-resume
```

## Shell Prompt
To get access to a shell (useful for running scripts directly on the container instead jupyter notebook), use the following command
```
make docker-shell
```
Your current working directly is mounted inside the docker container in `/notebooks` folder so do a `cd /notebooks` to get to your scripts.

## Installing your Own Set of Packages
If you ever need to install a custom package not provided by the image you can do so by dropping into the shell and installing the package with pip

```
pip install the_package_you_need
```

## Recreating the container
If you feel that you've broken your packages by trying to install something buggy, you can try to recreate the container

```
make docker-clean
make docker-run
```

## Making your Changes Persistent

Recreating the container will remove any custom packages that you might have installed. If you end up installing a lot of new tools and make them persistent across the containers, it's better to make a new image. Trace the following steps

* Set a custom name to your image `IMAGE=your_custom_image_name` in the `Makefile`.
* Add the install commands into the the `Dockerfile` followed by `RUN` directive. e.g.
    ```
    RUN pip install the_package_you_need
    ```
* Build the image with `make docker-build`
* Run the container us usual with either `make docker-run` or `make docker-resume` command

