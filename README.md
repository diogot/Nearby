# Nearby


## Dependencies

### [CocoaPods](https://cocoapods.org)

`$ (sudo) gem install cocoapods`

### [CoocaPods Keys](https://github.com/orta/cocoapods-keys)

```
$ (sudo) gem install cocoapods-keys
$ pod keys set FoursquareClientID <KEY>
$ pod keys set FoursquareClientSecret <KEY>
```

#### Possible issue in CocoaPods-Keys instalation

It's possible to get an error like:

`[!] Invalid 'Podfile' file: undefined method 'deep_stringify_keys' for...`

Like found [here](https://github.com/CocoaPods/CocoaPods/issues/3076).
The solution is:

`$ (sudo) gem install activesupport`
