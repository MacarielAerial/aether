# Aether

## Executive Summary

Top level project to link various microservice components together for a web application.

The project contains both deployment logic for the application itself and its infrastructure.

## Code Snippets

1. Swap all placeholder names in the repo with actual names

    ```
    # Placeholders include "aether", "exampledomain.com" and "exampleservice"
    ```

1. Make available environmental variables including credentials

    ```sh
    set -a; source .env; set +a
    ```

2. Bake the image with Packer and Ansible

    ```sh
    ( cd packer/ && packer init ./ && packer build . )
    ```

3. Deploy infrastructure with OpenTofu with the baked image

    ```sh
    tofu apply --auto-approve
    ```
