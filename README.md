A simple script to get you started with ML development within a docker container. It assumes you don't know much about Docker and takes you right into your development environment without breaking a sweat.
This particular image comes pre configured with **pytorch**, **tensorflow**, **keras**, **scikit-learn** and a few other ML tool-chain so you can start coding in your favorite framework right away in **jupyter-notebook**.

# Quickstart
Open the `Makefile` and change the values of the following variables
* `CONTAINER`: Use `azmfaridee/dl` in the image name field if you want to use the pre-built image otherwise, assign your own name for the image and build with `make docker-build` command
* `CONTAINER`: Assign an easily identifiable name for your docker container e.g. `faridee_project1`
* `AVAILABLE_GPUS`: Index starts at `0` and ends at `3`. Use comma separated values if you need more than one gpu, e.g. `AVAILABLE_GPUS=2,3`
* Modify all the port numbers so that there's no conflict with other users
    * `LOCAL_JUPYTER_PORT`
    * `LOCAL_TENSORBOARD_PORT`
    * `VSCODE_PORT`
* Finally, change `PASSWORD` to your desired value, you'll use this password to access your jupyter notebook and vscode development environment.

To run the docker container for the first time, use the following command:
```
make docker-run
```
You should see a prompt as following:

```
NV_GPU='0' docker run -it -p 18443:8443 -p 18888:8888 -p \
        16006:6006 -p 18787:8787 -v /home/azmfaridee/Documents/projects/mpsc/docker-scripts:/notebooks --name faridee_project1 azmfaridee/dl
[I 18:33:05.793 NotebookApp] Writing notebook server cookie secret to /root/.local/share/jupyter/runtime/notebook_cookie_secret
[I 18:33:05.997 NotebookApp] [jupyter_nbextensions_configurator] enabled 0.4.1
[I 18:33:05.998 NotebookApp] Serving notebooks from local directory: /notebooks
[I 18:33:05.998 NotebookApp] The Jupyter Notebook is running at:
[I 18:33:05.998 NotebookApp] http://34a6a9a3fc1f:8888/?token=...
[I 18:33:05.998 NotebookApp]  or http://127.0.0.1:8888/?token=...
[I 18:33:05.998 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[W 18:33:06.002 NotebookApp] No web browser found: could not locate runnable browser.
```

Point your browser to the provided url from the prompt with the following changes
* If you are running the container in a remote server and you know the remote IP, replace `127.0.0.1` with the remote IP e.g. `172.217.15.110`
* Change the port `8888` again to your `LOCAL_JUPYTER_PORT`.

So url 
```
http://127.0.0.1:8888/
``` 

should become 

```
http://172.217.15.110:18888/
``` 

in this example. Now use the `PASSWORD` you defined earlier to access your jupyter notebook

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

Recreating the container will remove any custom packages that you might have installed. If you end up installing a lot of new tools and want make them persistent across the containers, it's better to make a new image. Trace the following steps

* Set a custom name to your image `IMAGE=your_custom_image_name` in the `Makefile`.
* Add the install commands into the the `Dockerfile` followed by `RUN` directive. e.g.
    ```
    RUN pip install the_package_you_need
    ```
* Build the image with `make docker-build`
* Run the container us usual with either `make docker-run` or `make docker-resume` command

## Accessing The Docker Container Behind Firewall

If you're running the container on a server behind firewall, use ssh tunnel to access the jupyter notebook

```
ssh -L local_port:remote_ip:remote_port user@remote_ip -fNT
```

So if your jupyter notebook is hosted at `11888` port on a remote server `jupyter.remoteserver.com`, and you want to access it on your pc at `8888` port, the command should look like

```
ssh -L 8888:jupyter.remoteserver.com:11888 -fNT
```

