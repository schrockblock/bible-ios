# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
use_frameworks!

def import_pods
    pod 'Fabric'
    pod 'Google-Mobile-Ads-SDK'
    pod 'Crashlytics'
    pod "BibleManager", git: "https://github.com/ThryvInc/bible-manager-ios.git"
    pod "PH4BibleManager", git: "https://github.com/schrockblock/ph4bible-pod.git"
end

target 'Bible' do
    import_pods
    
    target 'BibleTests' do
        inherit! :search_paths
        # Pods for testing
    end
end

target 'NKJV Bible' do
    import_pods
    
    target 'NKJV BibleTests' do
        inherit! :search_paths
        # Pods for testing
    end
end

target 'KJV Bible' do
    import_pods
    
    target 'KJV BibleTests' do
        inherit! :search_paths
        # Pods for testing
    end
end

target 'NIV Bible' do
    import_pods
    
    target 'NIV BibleTests' do
        inherit! :search_paths
        # Pods for testing
    end
end
