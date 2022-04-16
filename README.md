## Skima Framework

Skima Framework was born with the intention of standardizing the development of applications with SDUI and creating tools to facilitate the creation and maintenance of applications at any scale.

The complete documentation is available in [Skima Docs](https://skima-framework.github.io/skima-docs/)

## Libraries for iOS

**Step 1:** Install the Skima library, which has all the Core logic of the framework:

```bash title="Podfile"
pod 'Skima'
```

**Step 2:** Create custom widgets or use some UI library. In our case we will use the SkimaStandardUI:

```bash title="Podfile"
pod 'SkimaStandardUI'
```

**Step 3:** Create custom actions or use any Actions library. In our case we will use the SkimaStandardActions:

```bash title="Podfile"
pod 'SkimaStandardActions'
```

Done! With these three libraries you already have everything installed!!

## Code in your app

### Register modules

Both the Actions and Widgets modules must be registered in Skima. For this, in the `AppDelegate` place:

```js title="AppDelegate.swift"
import Skima
import SkimaStandardUI
import SkimaStandardActions

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    WidgetsEngine.shared.registerOrReplace(SkimaStandardUI.self) // Here the Widgets module is registered
    ActionsEngine.shared.registerOrReplace(SkimaStandardActions.self) // Here the Actions module is registered

    return true
}
```

### Create screens

To use a screen from a Skima contract we can use the `SkimaViewController` which receives in its constructor the url from which to download the contract:

```js
let viewController = SkimaViewController(fromEndpoint: "https://...")
```

If what you want is to start the application from a contract you can place the following method in the `SceneDelegate`:

```js
import Skima

func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: scene)

    let viewController = SkimaViewController(fromEndpoint: "https://...")
    let navigationController = UINavigationController(rootViewController: viewController)
    NavigationEngine.shared.setNavigationController(navigationController) // This tells Skima which navigationController to use for navigation
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
}
```

#### Test Screens

To quickly test that everything is ok you can use the following screen contract as a demo:

```
https://run.mocky.io/v3/f960b018-feca-4860-bcaf-b31b66bd95b7
```

## Create your own Widgets

Each Widget has three parts: 1. props model, 2. widget's class, 3. Manipulators. So, lets create a simple Label widget as example!

### Step 1: Create the props model

The props model is a struct that conform the WidgetPropsType protocol:

```js title="LabelProps.swift"
import Skima

struct LabelProps: WidgetPropsType {
    var text: String?
    var fontSize: Double?
}
```

### Step 2: Create the Widget class

The Widget class must conform the UIWidget protocol:

```js title="Label.swift"
import UIKit
import Skima

class Label: UILabel, UIWidget {
    static var manipulators: [ActionSchema] = []

    var widget: Widget
    private var props: LabelProps?

    required init(from: widget Widget) {
        self.widget = widget
        self.props = widget.props as? LabelProps
        super.init(frame: .zero)
        configureView()
    }

    private func configureView() {
        setText(text: props?.text)
        setFontSize(props?.fontSize)
    }

    private func setText(text: String?) {
        self.text = text
    }

    private func setFontSize(size: Double?) {
        guard let _size = size else { return }
        font = font.withSize(CGFloat(_size))
    }
}
```

### Step 3: Create the manipulators

The manipulators are Actions that are applied to a given Widget, for example to change its color, its content or its state.

To create a Widget manipulator we need to create a class that conform the WidgetManipulatorData protocol and include this class in the manipulators array of the Widget itself:

```js title="LabelManipulator.swift"
import Skima

class LabelManipulator: WidgetManipulatorData {
    var widgetId: String?
    var type: String?
    var value: String?

    func execute(from scopes: [Scope]?) {
        guard let _widgetId = widgetId,
              let _widget = WidgetsEngine.shared.getWidgetBy(id: _widgetId, from: scopes) as? Label
        else { return }

        switch type {
        case "change_text":
            widget.setText(value)
        default:
            break
        }
    }

}
```

Then, back in the Widget class:

```js title="Label.swift"
...
class Label: UILabel, UIWidget {
    static var manipulators = [ActionSchema(type: "labelManipulation", actionData: LabelManipulator.self)]

...
```

That's it, you have created your own Skima Widget! Now there is only one step left...

### Step 4: Registering the Widget in your app

Now we need to let Skima know the new Widget so we have to register it. To do that we have to code:

```js title="AppDelegate.swift"
import Skima

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    WidgetsEngine.shared.registerOrReplace(WidgetSchema(type: "label", view: Label.self, props: LabelProps.self)) // Label is the new Widget
    return true
}
```

We did it in the `AppDelegate` but you can do it wherever you want.

### Step 5: Use the Widget from the BFF

Now we can use the new Widget with the following JSON:

```js
{
    "type": "label",
    "id": "label_1",
    "props": {
        "text": "Hello Skima!",
        "fontSize": 16
    }
}
```

If we want to change its text we use the following action:

```js
{
    "type": "labelManipulation",
    "data": {
        "widgetId": "label_1",
        "type": "change_text",
        "value": "This is the new text"
    }
}
```

## Create your own Actions

Creating an Action is even simpler!

### Step 1: Create the ActionData model

The ActionData struct will have the data of the action and its logic. It must conform the ActionDataType protocol:

```js title="CloseAppActionData.swift"
import Skima

struct CloseAppActionData: ACtionDataType {
    let consoleMessage: String?

    func execute(from scopes: [Scope]?) {
        print(consoleMessage)
        NSApplication.shared.terminate(self)
    }
}

```

### Step 2: Register the Action in your app

Now we need to let Skima know the new Action so we have to register it. To do that we have to code:

```js title="AppDelegate.swift"
import Skima

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    ActionsEngine.shared.registerOrReplace(ActionSchema(type: "close_app", CloseAppActionData: LabelProps.self)) // close_app is the new Widget
    return true
}
```

We did it in the `AppDelegate` but you can do it wherever you want.

### Step 3: Use the Action from the BFF

Now we can use the new Action with the following JSON:

```js
{
    "type": "close_app",
    "data": {
        "consoleMessage": "Closing the app..."
    }
}
```
