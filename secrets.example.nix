rec {
  wireless = {
    ssid = "your wifi ssid";
    password = "your wifi password";
  };

  installerPasswords = {
    root = "password";
  };

  ssh = {
    port = tcpPorts.ssh;
    authorizedKeys = [
      "ssh key for main user"
    ];
  };

  tcpPorts = {
    pihole = 31415;
    syncthing = 31416;
    ssh = 31417;
  };

  syncthing = {
    devices = {
      dickhead = "device id";
      sakomadik = "device id";
    };
    gui = {
      port = tcpPorts.syncthing;
      username = "artemis";
      password = "hashed password";
    };
  };
}
