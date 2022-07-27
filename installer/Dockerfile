FROM multiarch/qemu-user-static:x86_64-aarch64 as qemu

FROM nixos/nix

WORKDIR /opt

COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin

RUN echo 'extra-platforms = aarch64-linux' >> /etc/nix/nix.conf;

RUN nix-env -iA nixpkgs.gnumake

COPY ./Makefile .
RUN make setup

COPY ./secrets.nix .
COPY ./installer/* ./installer/
COPY . ./infra-repo/

CMD ["/bin/sh", "./installer/build.sh"]
