{...}: {
  specialisation.gpu-passthrough.configuration = {
    boot.kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
      "vfio-pci.ids=1002:7550,1002:ab40" # 9070 GPU + audio function only — NOT the APU
      "hugepagesz=1G"
      "hugepages=16" # adjust to VM RAM allocation
    ];

    boot.kernelModules = ["vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd"];
    boot.initrd.availableKernelModules = ["vfio_pci" "vfio" "vfio_iommu_type1"];

    # amdgpu still needs to bind the APU (0f:00.0) for host display —
    # vfio-pci.ids scopes to the 9070's IDs specifically, so amdgpu is safe
    # to load for the APU. softdep only matters if both cards ever share
    # a device ID, which they don't here (7550 vs 164e).
    boot.initrd.kernelModules = ["amdgpu" "vfio_pci"];

    boot.extraModprobeConfig = ''
      options vfio-pci ids=1002:7550,1002:ab40
    '';
    networking = {
      bridges."br0".interfaces = ["eno1"];

      # move eno1's role to br0 — eno1 becomes a slave, no IP of its own
      interfaces.br0.useDHCP = true;
      interfaces.eno1.useDHCP = false;
    };

    # NetworkManager will try to manage br0 and fight libvirt over it —
    # tell it to leave interfaces starting with vnet/virbr/br0 alone
    networking.networkmanager.unmanaged = ["interface-name:br0" "interface-name:vnet*"];
  };
}
