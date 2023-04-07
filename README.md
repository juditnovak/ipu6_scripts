# ipu6_scripts

Scripts performing automated build of [IPU6 drivers from source](https://github.com/intel/ipu6-drivers)


# Rationale

With a primary intent to facilitate my own life, allowing for

 - tracability
 - reproducability
 - simplified output collection
 - easy switch between types of attempts

I've assembled scripts that allow to easily test (and clean up) the various IPU6 drivers installation as local build.


# Description

Content of this repository is to follow and facilitate methods described in https://github.com/intel/ipu6-drivers.

**Disclaimer**: The scripts are performing a list of admin tasks, installing/removing drivers, kernel modules, packages, etc. I strongly suggest you to take a look at the scripts before running any if them!

The chosen flavor is IPU6EP (Alder Lake). Easy to alter for installation (see env. var. at top of the scripts).

NOTE: The cleanup script may be incomplete in the current state, for other flavors.

## Build/Installation

The script is hardly more than literally copy-pasted from the instructions found for each of the essential sources, in an order.

You will find corresponding comments within each section of the script, preserving clarity -- especially in case when any divergence from the docs may have happened.

So far you can find a script for method 2. and 3. described here, building together with the kernel is likely to come soon.


## Cleanup

Furthermore a cleanup script is also provided to clean up all traces of previously installed ipu6 modules.

**NOTE**: **Beware** the script performs a cleanup on ALL broken links in /usr/lib

