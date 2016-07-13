# RequireJS
[RequireJS官网](http://requirejs.org/)

[RequireJS中文网](http://www.requirejs.cn/)

[RequireJS学习笔记](http://www.cnblogs.com/yexiaochai/p/3214926.html)

RequireJS采用不同的方法来加载脚本，鼓励模块化编程，不但可以模块化编程，而且依旧可以运行得很快。
RequireJS鼓励使用模块ID，而不是像原来那样使用script标签使用url引用。
RequireJS加载代码时，其相对路径为baseUrl，baseUrl通常被设置为data-main指定文件的目录。
baseUrl可以通过设置进行手动配置（通过RequireJS），若没有在config中进行配置，且script标签没有指定data-main，则默认目录为RequireJS的HTML页面目录。
默认情况下不要在模块id上加上.js后缀，requireJS会在运行时自己加上。

## 加载JavaScript文件
RequireJS以一个相对于baseUrl的地址来加载所有的代码。
页面顶层`<script>`标签含有一个特殊的属性data-main，require.js使用它来启动脚本加载过程，而baseUrl一般设置到与该属性相一致的目录。

```
<script data-main="scripts/main.js" src="scripts/require.js"></script>
```

**Comment:**

1.三方库如jQuery没有将版本号包含在他们的文件名中。我们建议将版本信息放置在单独的文件中来进行跟踪。
使用诸如volo这类的工具，可以将package.json打上版本信息，并在磁盘上保持文件名为"jquery.js"。
这有助于你保持配置的最小化，避免为每个库版本设置一条path。

2.每个加载的脚本都是通过define()来定义的一个模块；但有些“浏览器全局变量注入”型的传统/遗留库并没有使用`define()`来定义它们的依赖关系，必须为此使用`shim config`来指明它们的依赖关系。

## data-main入口点
你可以在data-main指向的脚本中设置模板加载选项，然后加载第一个应用模块。

**Comment：**

你在main.js中所设置的脚本是异步加载的。所以如果你在页面中配置了其它JS加载，则不能保证它们所依赖的JS已经加载成功。
```
<script data-main="scripts/main" src="scripts/require.js"></script>
<script src="scripts/other.js"></script>
```
## 定义模块
模块不同于传统的脚本文件，良好地定义了一个作用域来避免全局名称空间污染，可以显式的列出其依赖关系，并以函数（定义此模块的那个函数）参数的形式将这些依赖进行注入，而无需引用全局变量。
RequireJS的模块是模块模式的一个扩展，其好处是无需全局地引用其他模块。
RequireJS的模块语法允许它尽快地加载多个模块，虽然加载的顺序不定，但依赖的顺序最终是正确的。同时因为无需创建全局变量，甚至可以做到在同一个页面上同时加载同一模块的不同版本。
**简单的值对:**如果一个模块仅含值对，没有任何依赖，则在define()中定义这些值对就好了。
```
//Inside file my/shirt.js:
define({
    color: "black",
    size: "unisize"
});
```

**函数式定义:**如果一个模块没有任何依赖，但需要一个做setup工作的函数，则在define()中定义该函数，并将其传给define().
```
//my/shirt.js now does setup work
//before returning its module definition.
define(function () {
    //Do setup work here

    return {
        color: "black",
        size: "unisize"
    }
});
```

**存在依赖的函数式定义:**如果模块存在依赖：则第一个参数是依赖的名称数组；第二个参数是函数，在模块的所有依赖加载完毕后，该函数会被调用来定义该模块，因此该模块应该返回一个定义了本模块的object。
依赖关系会以参数的形式注入到该函数上，参数列表与依赖名称列表一一对应。
```
//my/shirt.js now has some dependencies, a cart and inventory
//module in the same directory as shirt.js
define(["./cart", "./inventory"], function(cart, inventory) {
        //return an object to define the "my/shirt" module.
        return {
            color: "blue",
            size: "large",
            addToCart: function() {
                inventory.decrement(this);
                cart.add(this);
            }
        }
    }
);
```

## 将模块定义为一个函数
对模块的返回值类型并没有强制为一定是个object，任何函数的返回值都是允许的。此处是一个返回了函数的模块定义：
```
define(["my/cart", "my/inventory"],
    function(cart, inventory) {
        //return a function to define "foo/title".
        //It gets or sets the window title.
        return function(title) {
            return title ? (window.title = title) :
                   inventory.storeName + ' ' + cart.name;
        }
    }
);
```

## 定义一个命名模块
可能会看到一些define()中包含了一个模块名称作为首个参数:
```
//Explicitly defines the "foo/title" module:
define("foo/title",
    ["my/cart", "my/inventory"],
    function(cart, inventory) {
        //Define foo/title object in here.
    }
);
```

## shim配置
shim: 为那些没有使用define()来声明依赖关系、设置模块的"浏览器全局变量注入"型脚本做依赖和导出配置。
那些仅作为jQuery或Backbone的插件存在而不导出任何模块变量的"模块"们，shim配置可简单设置为依赖数组：
```
requirejs.config({
    shim: {
        'jquery.colorize': ['jquery'],
        'jquery.scroll': ['jquery'],
        'backbone.layoutmanager': ['backbone']
    }
});
```