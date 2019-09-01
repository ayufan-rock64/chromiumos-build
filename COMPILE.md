# Compile

1. Create `.env` file:

    ```bash
    cat <<EOF > .env
    # Use if you want to publish packages to GitHub Releases
    export GITHUB_USER=ayufan-rock64
    export GITHUB_REPO=chromiumos-build
    export GITHUB_TOKEN=API_TOKEN

    # Google Chrome API keys:
    # Request own API keys, this is needed if you want to be able to login
    export GOOGLE_API_KEY=API_KEY
    export GOOGLE_DEFAULT_CLIENT_ID=424119844901-tilod0e1nm0dt85e1evrdfp3cc3ec01d.apps.googleusercontent.com
    export GOOGLE_DEFAULT_CLIENT_SECRET=CLIENT_SECRET
    EOF
    ```

1. Create work directory, this requires around 100GB of free disk space:

    ```bash
    ./cros_init.sh /opt/sources/chromium release-R77-12371.B
    ```

1. Apply patches:

    ```bash
    ./cros_run.sh /opt/sources/chromium ~/trunk/src/overlays/overlay-rockpro64/do_apply_patches.sh
    ```

1. Compile, this will take between 4 to 12 hours:

    ```bash
    ./cros_run.sh /opt/sources/chromium ~/trunk/src/overlays/overlay-rockpro64/do_release_and_publish.sh 1
    ```

  The `1` is build number.
