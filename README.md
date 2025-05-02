# WebUI

<h2 align="center">
  <a href="https://github.com/dec0dOS/amazing-github-template">
    <img src="https://github.com/user-attachments/assets/657945a9-5540-4abb-a107-4f6547e4a77e" alt="Logo" width="300">
  </a>
</h2>

<div align="center">
  A library for generating Web User Interfaces in a simple, type-safe, and consistent manner.
  <br />
  <br />
  <a href="https://github.com/maclong9/web-ui/issues/new?assignees=&labels=bug&template=01_BUG_REPORT.md&title=bug%3A+">Report a Bug</a>
  ·
  <a href="https://github.com/maclong9/web-ui/issues/new?assignees=&labels=enhancement&template=02_FEATURE_REQUEST.md&title=feat%3A+">Request a Feature</a>
  ·
  <a href="https://github.com/maclong9/web-ui/discussions">Ask a Question</a>
</div>

<div align="center">
<br />

[![license](https://img.shields.io/github/license/maclong9/web-ui.svg?style=flat-square)](LICENSE)
[![PRs welcome](https://img.shields.io/badge/PRs-welcome-ff69b4.svg?style=flat-square)](https://github.com/maclong9/web-ui/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)
[![Automated Release](https://github.com/maclong9/web-ui/actions/workflows/release.yml/badge.svg)](https://github.com/maclong9/web-ui/actions/workflows/release.yml)

</div>

<details open="open">
<summary>Table of Contents</summary>

- [About](#about)
  - [Built With](#built-with)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Usage](#usage)
  - [Adding WebUI to a Swift Package Manager (SPM) project](#adding-webui-to-a-swift-package-manager-spm-project)
- [Development](#development)
- [Contributing](#contributing)
- [Support](#support)
- [License](#license)
- [Acknowledgements](#acknowledgements)

</details>

## About

WebUI is a library for generating Web User Interfaces in a simple, type-safe,
and consistent manner. It is inspired by modern web development practices and
aims to provide a seamless experience for developers building static sites or
dynamic web applications.

### Built With

- [Swift](https://swift.org)
- [Tailwind CSS](https://tailwindcss.com)
- [Apple Swift Logging](https://github.com/apple/swift-log)
- [Swift Markdown](https://github.com/apple/swift-markdown)

## Getting Started

### Prerequisites

To use WebUI, ensure you have the following installed:

- Swift 6.1 or later
- macOS 13 or later

### Usage

Refer to the
[Static Site Generation with WebUI](https://maclong.uk/articles/introduction-to-webui)
guide for detailed instructions on how to get started.

### Adding WebUI to a Swift Package Manager (SPM) project

To add WebUI to your Swift project using the Swift Package Manager, follow these
steps:

1. Open your `Package.swift` file.
2. Add the WebUI repository URL to the `dependencies` array.

```swift
dependencies: [
    // Add the WebUI package dependency
    .package(url: "https://github.com/maclong9/web-ui.git", from: "1.0.0")
],
```

3. Include `WebUI` as a dependency for your target(s):

```swift
targets: [
    .target(
        name: "YourTargetName",
        dependencies: [
            .product(name: "WebUI", package: "web-ui")
        ]
    ),
]
```

4. Save the `Package.swift` file and run the following command in your terminal
   to fetch the dependencies:

```sh
swift package update
```

5. You can now import and use WebUI in your project files:

```swift
import WebUI
```

## Development

### Versioning

Version bumps are triggered automatically via commit messages. Use the following
prefixes:

- `feat!:` - Major version increment for breaking changes.
- `feat:` - Minor version increment for new features.
- `fix:` - Patch version increment for bug fixes.

## Contributing

Contributions are what make the open-source community such an amazing place to
learn, inspire, and create. Any contributions you make will benefit everybody
else and are greatly appreciated.

Please adhere to this project's [code of conduct](CODE_OF_CONDUCT.md).

## Support

Reach out to the maintainer at one of the following places:

- [GitHub discussions](https://github.com/maclong9/web-ui/discussions)
- The email located in the [GitHub profile](https://github.com/maclong9)

## License

This project is licensed under the **MIT license**. See [LICENSE](LICENSE) for
more information.

## Acknowledgements

Thanks to the following resources that inspired WebUI:

- [Apple Developer](https://developer.apple.com/videos/play/wwdc2021/10253/)
- [Hacking with Swift](https://www.hackingwithswift.com/articles/266/build-your-next-website-in-swift)
- [Elementary](https://github.com/sliemeobn/elementary/tree/main)
- [Tailwind](http://tailwindcss.com)
