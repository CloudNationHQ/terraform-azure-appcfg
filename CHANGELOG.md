# Changelog

## [2.1.1](https://github.com/CloudNationHQ/terraform-azure-appcfg/compare/v2.1.0...v2.1.1) (2025-07-08)


### Bug Fixes

* identity block ([#20](https://github.com/CloudNationHQ/terraform-azure-appcfg/issues/20)) ([5d6eeee](https://github.com/CloudNationHQ/terraform-azure-appcfg/commit/5d6eeeedddf44d83328e27c5c64f2dce05a0658e))

## [2.1.0](https://github.com/CloudNationHQ/terraform-azure-appcfg/compare/v2.0.0...v2.1.0) (2025-07-08)


### Features

* Add identity block ([#18](https://github.com/CloudNationHQ/terraform-azure-appcfg/issues/18)) ([1069e8f](https://github.com/CloudNationHQ/terraform-azure-appcfg/commit/1069e8fcc62cf38e0a5a3983366cbf2d1f8bbd41))

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-appcfg/compare/v1.1.1...v2.0.0) (2025-05-09)


### ⚠ BREAKING CHANGES

* The data structure changed, causing a recreate on existing resources.

### Features

* add type definitions ([#14](https://github.com/CloudNationHQ/terraform-azure-appcfg/issues/14)) ([cdf6ac1](https://github.com/CloudNationHQ/terraform-azure-appcfg/commit/cdf6ac1df8ad4b469e1b305b24502eaed903f914))
* **deps:** bump golang.org/x/crypto from 0.32.0 to 0.35.0 in /tests ([#12](https://github.com/CloudNationHQ/terraform-azure-appcfg/issues/12)) ([b42ff5b](https://github.com/CloudNationHQ/terraform-azure-appcfg/commit/b42ff5b32da712a239f55ca4b8d170bfa074e7aa))
* **deps:** bump golang.org/x/net from 0.34.0 to 0.38.0 in /tests ([#13](https://github.com/CloudNationHQ/terraform-azure-appcfg/issues/13)) ([6094f16](https://github.com/CloudNationHQ/terraform-azure-appcfg/commit/6094f167271bb5c762ad17881433a6769a747af8))
* small refactor ([#16](https://github.com/CloudNationHQ/terraform-azure-appcfg/issues/16)) ([ffa3b24](https://github.com/CloudNationHQ/terraform-azure-appcfg/commit/ffa3b249cfe244e3b1ee93b4884ceb736f83bcf4))

### Upgrade from v1.1.1 to v2.0.0:

- Update module reference to: `version = "~> 2.0"`
- The property and variable resource_group is renamed to resource_group_name

## [1.1.1](https://github.com/CloudNationHQ/terraform-azure-appcfg/compare/v1.1.0...v1.1.1) (2025-03-07)


### Bug Fixes

* move app configuration data owner role assignment to parent module ([#8](https://github.com/CloudNationHQ/terraform-azure-appcfg/issues/8)) ([43af01d](https://github.com/CloudNationHQ/terraform-azure-appcfg/commit/43af01db73b5f5634963c4d79eaf9cec60e772fa))

## [1.1.0](https://github.com/CloudNationHQ/terraform-azure-appcfg/compare/v1.0.0...v1.1.0) (2025-03-07)


### Features

* move keys to a submodule ([#6](https://github.com/CloudNationHQ/terraform-azure-appcfg/issues/6)) ([6bfbc14](https://github.com/CloudNationHQ/terraform-azure-appcfg/commit/6bfbc14bd5ffa1568cc5aa2d44df3bc7e114be51))

## 1.0.0 (2025-03-06)


### Features

* add initial files ([#2](https://github.com/CloudNationHQ/terraform-azure-appcfg/issues/2)) ([2400e4a](https://github.com/CloudNationHQ/terraform-azure-appcfg/commit/2400e4a30af10789bf21bf87c8ea912097d97137))
