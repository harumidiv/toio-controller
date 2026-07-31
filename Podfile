platform :ios, '13.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end

  # Fix RxBluetoothKit 6.0.0 compatibility with Xcode 15+ CoreBluetooth nullability changes
  rx_source = "#{installer.sandbox.root}/RxBluetoothKit/Source"
  {
    "#{rx_source}/Characteristic.swift" => [
      ["characteristic.service)", "characteristic.service!)"]
    ],
    "#{rx_source}/Descriptor.swift" => [
      ["descriptor.characteristic.service)", "descriptor.characteristic!.service!)"],
      ["descriptor.characteristic, service:", "descriptor.characteristic!, service:"]
    ],
    "#{rx_source}/CentralManagerRestoredState.swift" => [
      ["cbServices.map { Service(peripheral: centralManager.retrievePeripheral(for: $0.peripheral),",
       "cbServices.compactMap { Service(peripheral: centralManager.retrievePeripheral(for: $0.peripheral!),"]
    ]
  }.each do |path, replacements|
    next unless File.exist?(path)
    File.chmod(0644, path)
    content = File.read(path)
    replacements.each { |from, to| content.gsub!(from, to) }
    File.write(path, content)
  end
end

target 'ToioController' do
  use_frameworks!

  pod 'SwiftLint'
  pod 'SwiftFormat/CLI'
  pod 'LicensePlist'
  pod 'RxBluetoothKit'
  pod 'Swinject'
  pod 'lottie-ios'
  pod 'R.swift'

  ## test ----------------------------------

  target 'ToioControllerTests' do
    inherit! :search_paths
      end

  target 'ToioControllerUITests' do
    inherit! :search_paths
        pod 'SwiftLint'
        pod 'SwiftFormat/CLI'
        pod 'LicensePlist'
        pod 'RxBluetoothKit'
        pod 'Swinject'
        pod 'lottie-ios'
      end
end
