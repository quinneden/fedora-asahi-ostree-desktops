FROM quay.io/centos-bootc/centos-bootc:stream9

RUN cd /etc/yum.repos.d/ && curl -OL https://copr.fedorainfracloud.org/coprs/g/asahi/kernel/repo/fedora-39/group_asahi-kernel-fedora-39.repo && curl -OL https://copr.fedorainfracloud.org/coprs/g/asahi/mesa/repo/fedora-39/group_asahi-mesa-fedora-39.repo && curl -OL https://copr.fedorainfracloud.org/coprs/g/asahi/fedora-remix-branding/repo/fedora-39/group_asahi-fedora-remix-branding-fedora-39.repo && curl -OL https://copr.fedorainfracloud.org/coprs/g/asahi/fedora-remix-scripts/repo/fedora-39/group_asahi-fedora-remix-scripts-fedora-39.repo && curl -OL https://copr.fedorainfracloud.org/coprs/g/asahi/u-boot/repo/fedora-39/group_asahi-u-boot-fedora-39.repo && curl -OL https://github.com/quinneden/fedora-asahi-ostree-desktops/raw/kinoite/fedora-repos/fedora.repo && curl -OL https://github.com/quinneden/fedora-asahi-ostree-desktops/raw/kinoite/fedora-repos/fedora-updates.repo && curl -OL https://github.com/quinneden/fedora-asahi-ostree-desktops/raw/kinoite/fedora-repos/fedora-updates-testing.repo && curl -OL https://github.com/quinneden/fedora-asahi-ostree-desktops/raw/kinoite/fedora-repos/fedora-cisco-openh264.repo

# RUN rpm-ostree install --releasever=40 fedora-repos

RUN rpm-ostree install --releasever=40 alsa-ucm-asahi asahi-bless asahi-fwupdate asahi-scripts avahi-devel busybox codec2 crun-krun cups-devel dracut-asahi dracut-config-generic egl-utils glibc-minimal-langpack konsole yakuake google-noto-sans-arabic-vf-fonts im-chooser im-chooser-common imsettings imsettings-gsettings imsettings-libs initial-setup initial-setup-gui irqbalance json-devel keyutils-libs-devel krb5-devel libestr libfastjson librabbitmq libretls libtomcrypt libverto-devel linux-firmware-vendor lpcnetfreedv lzfse-libs m1n1 netcat openfec plymouth plymouth-graphics-libs plymouth-plugin-label plymouth-plugin-two-step plymouth-scripts plymouth-system-theme plymouth-theme-spinner pykickstart python3-asahi_firmware python3-asn1 python3-beaker python3-crypto python3-paste python3-pyOpenSSL python3-tempita qt5-qtbase-private-devel qt5-qtmultimedia-devel roc-toolkit rsyslog rsyslog-logrotate rust smartmontools smartmontools-selinux speexdsp-devel bootc

RUN if [ $(uname -m) = "aarch64" ]; then rpm-ostree install --releasever=40 grub2-efi-aa64 grub2-efi-aa64-modules shim-aa64 uboot-images-armv8 xorg-x11-drv-armsoc update-m1n1; fi

RUN rpm-ostree cliwrap install-to-root /
# Replace the kernel, kernel-core and kernel-modules packages.

RUN rpm-ostree override replace --experimental --from repo='copr:copr.fedorainfracloud.org:group_asahi:kernel' kernel-16k kernel-16k-core kernel-16k-modules kernel-16k-modules-core kernel-16k-modules-extra

RUN rpm-ostree override replace --experimental --from repo='copr:copr.fedorainfracloud.org:group_asahi:mesa' $(rpm -qa --queryformat "%{NAME}\n" | grep "^mesa" | xargs)
# RUN rpm-ostree override replace --experimental --from repo='copr:copr.fedorainfracloud.org:group_asahi:fedora-remix-branding' fedora-asahi-remix-release fedora-asahi-remix-release-ostree-desktop fedora-asahi-remix-release-identity-kinoite fedora-asahi-remix-release-kinoite

RUN rm -f /var/lib/unbound/root.key # workaround see https://github.com/fedora-silverblue/issue-tracker/issues/413

RUN ostree container commit
