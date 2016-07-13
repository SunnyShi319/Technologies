# sass(Syntactically Awesome Style Sheets)
[sass官网](http://sass-lang.com/)

[sass学习](http://www.w3cplus.com/sassguide/)

## 文件后缀名
一种后缀名为sass,不使用大括号和分号；
一种后缀名为scss,使用大括号和分号；
所有的sass文件都指后缀名为scss的文件，以避免sass后缀名的严格格式要求报错。

## 导入
sass的导入，编译时会将`@import`的scss文件合并进来只生成一个css文件.

如果在sass文件中导入css文件`如@import'reset.css'`，那效果跟普通的CSS导入样式文件一致，导入的css文件不会合并到编译后的文件中，而是以@import方式存在。

## 注释
一种是标准的css注释方式/* */
---- 标准的css注释

另一种则是//双斜杠形式的单行注释
---- 但行注释跟JavaScript语言中的注释一样，使用双斜杠(//)，但单行注释不会输入到CSS中

## 变量
sass的变量必须是$开头，后面紧跟变量名，而变量值和变量值之间就需要使用冒号`:`分隔开(就像CSS属性设置一样)
如果值后面加上!default则表示默认值。

**普通变量:**定义之后可以在全局范围内使用。

**默认变量:**sass的默认变量仅需要在值后面加上!default即可
*sass的默认变量一般是用来设置默认值的，然后根据需求来覆盖的，覆盖的方式很简单，只需要在默认变量之前重新声明一下变量即可。

**特殊变量:**一般定义的变量为属性值，可直接使用，但是如果变量作为属性或在某些特殊情况下等则必须要以`#{$variables}`形式使用。

**多值变量:**多值变量分为list类型和map类型，list像js中的数组，map像js中的对象

*List*
数据可通过空格，逗号或小括号分隔多个值，可用nth{$var,$index}取值。
关于list数据操作还有很多其他函数如length($list)，join($list1,$list2,[$separator])，append($list,$value,[$separator])等，具体可参考sass Functions（搜索List Functions即可）

*map*
数据以key和value成对出现，其中value又可以是list。格式为：$map: (key1: value1, key2: value2, key3: value3);。可通过map-get($map,$key)取值。
关于map数据还有很多其他函数如map-merge($map1,$map2)，map-keys($map)，map-values($map)等，具体可参考sass Functions（搜索Map Functions即可）

**全局变量:**在变量值后面加上!global即为全局变量，这个目前还用不上，不过将会在sass3.4后的版本中正式应用。
在选择器中声明的变量会覆盖外面全局声明的变量。

## 嵌套
sass的嵌套包括两种:一种是选择器的嵌套，另一种是属性的嵌套。

**选择器嵌套:**所谓选择器嵌套指的是在一个选择器中嵌套另一个选择器来实现继承，从而增强了sass文件的结构性和可读性。
在选择器嵌套中，可以使用&表示父元素选择器.

**属性嵌套:**所谓属性嵌套指的是有些属性拥有同一个开始单词，如border-width，border-color都是以border开头.

**@at-root:**用来跳出选择器嵌套的。默认所有的嵌套，继承所有上级选择器，但有了这个就可以跳出所有上级选择器。

