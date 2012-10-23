pe_enterprise installer
=====================

This is a proof of concept project to see what goes into getting a PE agent up and running.

This is more to provide documentation of how the agent is built, almost all in puppet code, than to be a working system.

This cheats a little bit, as it is only for centos 6, and is solely a puppet apply script, not really a module. Also I do a local loopback trick for yum repos, in production it would be assumed that the PE packages are already stored on your repo.
