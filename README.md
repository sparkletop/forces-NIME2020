# forces

This repository contains software developed for research into gesture-based musical interfaces, to be presented at the [New Interfaces for Musical Expression](https://www.nime.org/) conference in 2020. The software was designed to be used with the [Leap Motion controller](https://www.ultraleap.com/product/leap-motion-controller/) in order to test design principles for intuitive, gesture-based music interfaces.

The software consists of two main parts:

- A collection of interactive sound synthesis patches which respond to sensor data, built with SuperCollider
- A web browser-based user interface and initial sensor data processing, built with the LeapJS API and web technologies

## Getting started

### Installing

You need to install the following software first:

- [Node.js](https://nodejs.org/)
- [SuperCollider](https://supercollider.github.io/)
- [Leap Motion controller driver](https://developer.leapmotion.com/setup/desktop) (make sure to get the V2/legacy version for javascript support)

To install the software contained in this repository:

- [Clone](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository) this repository (or download the repository as a zip-file and unzip)
- Open a terminal and navigate to the cloned repository folder
- Run these commands:

```Shell
npm install
npm run build
```

These commands will install the necessary NPM packages and the most recent version of the LeapJS API from Leap Motion's github repository (for further details, see the package.json file), after which the user interface will be built.

### Running the software

There are three steps to starting up the software:

- Make sure your Leap Motion controller is connected and working properly

- Open the file synth/init.scd in the SuperCollider IDE and run the main block of code by placing your cursor somewhere in the document and pressing Cmd/Ctrl+Enter

- In a terminal, navigate to the root of the repository folder and run `npm run start`

You can now access the user interface in a browser at [http://localhost:3000](http://localhost:3000).

Technically, we are now running a simple web server on our local machine which connects the browser-based user interface with the SuperCollider program using a simple OSC bridge. Please note that the software has not been designed for deployment as a server on the internet and thus should only be run locally.

## Other notes

### Configuration

A few configuration parameters are defined in the config.json file. It should not be necessary to change these.

### Removing the software

To uninstall, simply delete the folder where the software resides - this will remove the NPM packages as well. For the other required software (node.js, SuperCollider, Leap Motion driver), see their respective documentation.

### Credits

The audio sample used in example 3 for timbral and tempo-related manipulation was provided by freesound.org user ["ajubamusic"](https://freesound.org/people/ajubamusic/) under the [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/) license.
