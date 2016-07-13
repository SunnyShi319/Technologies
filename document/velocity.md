# Velocity
[Velocity模版开源社区](http://www.oschina.net/p/velocity/)

[Velocity API](http://tool.oschina.net/apidocs/apidoc?api=velocity-1.7)

[Velocity模版引擎](http://www.ibm.com/developerworks/cn/java/j-lo-velocity1/)

## 概念
Velocity是一个基于Java的模板引擎框架，提供的模板语言可以使用在Java中定义的对象和变量上。
Velocity是Apache基金会的项目，开发的目标是分离MVC模式中的持久化层和业务层。但是在实际应用过程中，Velocity不仅仅被用在了MVC的架构中，还可以被用在以下一些场景中：
- Web应用: 开发者在不使用JSP的情况下，可以用Velocity让HTML具有动态内容的特性。
- 源代码生成: Velocity可以被用来生成Java代码、SQL或者PostScript。有很多开源和商业开发的软件是使用Velocity来开发的。
- 自动Email: 很多软件的用户注册、密码提醒或者报表都是使用 Velocity 来自动生成的。使用 Velocity 可以在文本文件里面生成邮件内容，而不是在 Java 代码中拼接字符串。
- 转换xml: Velocity 提供一个叫 Anakia 的 ant 任务，可以读取 XML 文件并让它能够被 Velocity 模板读取。一个比较普遍的应用是将 xdoc 文档转换成带样式的 HTML 文件。
- 模板服务: Velocity也可以为Turbine web开发架构提供模板服务(template service)。Velocity+Turbine提供一个模板服务的方式允许一个web应用以一个真正的MVC模型进行开发。

The Mud Store Example
Velocity使得web页面的客户化工作非常容易，作为一个web site的设计人员，希望每个用户登陆时都能拥有自己的页面，同意客户应该拥有个性化的信息。

## VTL statement
VTL意味着提供最简单、最容易并且最整洁的方式合并页面动态内容。

VTL使用references来在web site内嵌套动态内容，一个变量就是一种类型的reference。

变量是某种类型的reference，它可以指向Java代码中的定义，或者从当前页面内定义的VTL statement得到值。
eg: #set($a = "Velocity")
和所有的VTL statement一样，这个statement以#字符开始并且包含一个directive:set。

**Comment:**
- 当一个在线用户请求你的页面时，Velocity Templating Engine将查询整个页面以便发现所有#字符，然后确定哪些时VTL statement，哪些不需要VTL作任何事情。
*变量(和其他的reference一样以$字符开始)*被列在左边，而它的*值(总是以双引号封闭，Velocity中仅有String可以被赋值给变量)*被列在右边，最后它们使用=号分割。
- 使用$符号开始的references用于得到什么；使用#字符开始的directives用于作些什么
- 一旦某个变量被分配了一个值，那么你就可以在HTML文件的任何地方引用它
- 为了使包含VTL directives的statement更具有可读性，鼓励在新行开始每个VTL statement,尽管不是必须那么作。

## 注释
- 单行注释: ##This is a single line comment.
- 多行注释: 
           #*
            Thus begins a multi-line comment.
           *#
- 文档格式: 
           #**
            This is a VTL comment block and may be used to store such information.
           *#

## References
在VTL中有三种类型的references:变量(variables)、属性(properties)、方法(methods)。必须就references的名称达成共识，以便可以在template中使用它们。
- 变量
格式要求同Java

- 属性
eg: $customer.Address
它可以表示:查看hashtable对象customer中以Address为关键字的值；也可以表示调用customer对象的getAddress()方法。
当你的页面被请求时，Velocity将确定以上两种方式选用哪种，然后返回适当的值。

- 方法
一个方法就是被定义在Java中的一段代码，并且它有完成某些有用工作的能力，例如一个执行计算和判断条件是否成立、满足等。
方法是一个由$开始并跟随VTL标识组成的References，一般还包括一个VTL方法体。

**Compartor:**
VTL属性可以作为VTL方法的缩写，如果可能的话，使用属性的方式是比较合理的。属性和方法的不同点在于你能够给一个方法指定一个参数列表。

## 正式reference标记
reference的正式格式如下:
${mudSlinger} 变量
${customer.Address} 属性
${purchase.getTotal()} 方法
希望通过一个变量$vice来动态地组织一个字符串，应该使用正式格式书写${vice}

## Quiet reference notation
eg:`<input type=”text” name=”email” value=”$email” />`
当页面的form被初始加载时，变量$mail还没有值，这是肯定希望能够显示一个blank text来代替输出"$email"这样的字段，使用quiet reference notation就比较适合。
`<input type=”text” name=”email” value=”$!email” />`，正式地和quiet格式的reference notation也可一同使用，像这样：`<input type=”text” name=”email” value=”$!{email}” />`

## Getting literal
Velocity使用特殊字符$和#来帮助它工作，所以如果要在template里使用这些特殊字符要格外小心。
- 在VTL中使用$2.5这样的货币标识是没有问题得的，VTL不会将它错认为是一个reference，因为VTL中的reference总是以一个大写或者小写的字母开始；
- VTL中使用"\"作为逃逸符；
- VTL中未将定义的变量将被认为是一个字符串；

## Case substitution
Velocity利用了很多Java规范以方便了设计人员的使用。
注意:VTL中不会将reference解释为对象的实例变量。

## Directives
Reference允许设计者使用动态的内容，而directive使得你可以应用Java代码来控制显示逻辑，从而达到你所期望的显示效果。
- \#set
    
    \#set directive被用于设置一个reference的值。
    赋值左侧的(LHS)必须是一个变量或者属性reference,右侧(RHS)可以是以下类型中一种:
    - 变量reference
    - String literal
    - 属性reference
    - 方法reference
    - number literal
    - ArrayList
    **注意:**当RHS是一个null,VTL的处理将比较特殊，它将指向一个已经存在的reference，这对初学者来讲可能是比较费解的。为了解决这个问题，我们可以通过预先定义的方式，作事先的判断。
- String Literals
    
    当使用#set directive，String literal封闭在一对双引号内，则
    ```
    #set ( $directoryRoot = “www” )
    #set ( $templateName = “index.vm” )
    #set ( $template = “$directoryRoot/$tempateName” )
    $template
    ```
    上面这段代码的输出结果为:www/index.vm
    
    但是，当string literal被封装在单引号内时，它将不被解析:
    ```
    #set ( $foo = “bar” )
    $foo
    #set ( $blargh = ‘$foo’ )
    ```
    结果:
    bar
    $foo
    上面这个特性可以通过修改velocity.properties文件的stringliterals.interpolate=false的值来改变上面的特性是否有效。

## 条件语句
- if/elseif/else
当一个web页面被生成时使用Velocity的#if directive，如果条件成立的话可以在页面内嵌入文字。
```
#if ( $foo )
<strong>Velocity!</strong>
#end
```
上例中的条件语句将在以下两种条件下成立:
- $foo 是一个 boolean 型的变量,且它的值为 true
- $foo 变量的值不为 null

**注意:**Velocity context仅仅能够包含对象，所以所说的"boolean"实际上代表的是一个Boolean对象，即便某个方法返回的是一个boolean值，Velocity也会利用内省机制将它转换为一个Boolean的相同值。
注意这里的Velocity的数字是作为Integer来比较的--其他类型的对象将使得条件为false，但是与Java不同它使用"=="来比较两个值，而且Velocity要求等号两边的值类型相同。

- 关系、逻辑运算符
Velocity中使用等号操作符判断两个变量的关系，同时有AND、OR和NOT逻辑运算符。
```
## logical AND#if( $foo && $bar )
<strong> This AND that </strong>
#end
## logical OR
#if ( $foo || $bar )
<strong>This OR That </strong>
#end
##logical NOT
#if ( !$foo )
<strong> NOT that </strong>
#end
```

## 循环
- foreach循环

    遍历循环的可以是一个 Vector、Hashtable 或者 Array。分配给每个变量的值是一个Java 对象,并且可以通过变量被引用。
    $velocityCount变量的名字是Velocity默认的名字，可以通过修改velocity.properties文件来改变它。
    默认情况下，计数从"1"开始，但是你可以在velocity.properties设置它是从"1"还是从"0"开始。
- include

    \#include script element允许模板设计者引入本地文件，被引入文件的内容将不会通过模板引擎被render模板。
    - 为了安全的原因，被引入的本地文件只能在TEMPLATE_ROOT目录下。`#inclued ( “one.txt” )`
    - 如果需要引入多个文件，可以用逗号分隔就行。`#include ( “one.gif”, “two.txt”, “three.htm” )`
    - 在括号内可以是文件名，但更多的时候是使用变量的。`#inclue ( “greetings.txt”, $seasonalstock )`

- parse

    \#parse script element允许模板设计者一个包含VTL的本地文件。Velocity将解析其中的VTL并render模板。
    - 任何由#parse 指向的模板都必须包含在 TEMPLATE_ROOT 目录下
    - \#parse只能指定单个对象
    - 你可以通过修改 velocity.properties 文件的 parse_direcive.maxdepth 的值来控制一个template 可以包含的最多#parse 的个数――默认值是 10
    - \#parse是可以递归调用的。
    ```
    $count
    #set ( $count = $count – 1 )
    #if ( $count > 0 )
    #parse( “parsefoo.vm” )
    #else
    All done with parsefoo.vm!
    #end
    ```

- Stop
   
   \#stop script element允许模板设计者停止执行模板引擎并返回。把它应用于debug是很有帮助的。

- Velocimacros
   
   \#macro script element允许模板设计者定义一段可重用的VTL template.
   ```
   #macro ( d )
    <tr><td></td></tr>
   #end
   ```
   在上面的例子中 Velocimacro 被定义为 d,然后你就可以在任何 VTL directive 中以如下方式调用它:`#d()`
   当template被调用的时候，Velocity将用<tr><td></td></tr>替换成#d()
   ```
    当你的 template 被调用时,Velocity 将用<tr><td></td></tr>替换为#d()。每个 Velocimacro 可以拥有任意数量的参数――甚至 0 个参数,虽然定义时可以随意设置参数数量,但是调用这个 Velocimacro 时必须指定正确的参数。
    下面是一个拥有两个参数的 Velocimacro,一个参数是 color 另一个参数是 array:
    #macro ( tablerows $color $somelist )
    #foreach ( $something in $somelist )
    <tr><td bgcolor=$color>$something</td</tr>
    #end
    #end
    调用#tablerows Velocimacro:
    #set ( $greatlakes = [ “Superior”, “Michigan”, “Huron”, “Erie”, “Ontario” ] )
    #set ( $color = “blue” )
    <table>
    #tablerows( $color $greatlakes )
    </table>
    经过以上的调用将产生如下的显示结果:
    <table>
    <tr><td bgcolor=” blue”> Superior </td></tr>
    <tr><td bgcolor=” blue”> Michigan </td></tr>
    <tr><td bgcolor=” blue”> Huron </td></tr>
    <tr><td bgcolor=” blue”> Erie </td></tr>
    <tr><td bgcolor=” blue”> Ontario </td></tr>
    </table>
    Velocimacros 可以在 Velocity 模板内实现行内定义(inline),也就意味着同一个 web site内的其他 Velocity 模板不可以获得 Velocimacros 的定义。
    定义一个可以被所有模板共享的 Velocimacro 显然是有很多好处的:它减少了在一大堆模板中重复定义的数量、节省了工作时间、减少了出错的几率、保证了单点修改。
    上面定义的#tablerows( $color $list )Velocimacro 被定义在一个 Velocimacros 模板库(在 velocity.properties 中定义)里,所以这个 macro 可以在任何规范的模板中被调用。
    它可以被多次应用并且可以应用于不同的目的。例如下面的调用:
    #set ( $parts = [ “volva”, “stipe”, “annulus”, “gills”, “pileus” ] )
    #set ( $cellbgcol = “#CC00FF” )
    <table>
    #tablerows($cellbgcol $parts)
    </table>
    上面 VTL 将产生如下的输出:
    <table>
    <tr><td bgcolor=”#CC00FF”> volva </td</tr>
    <tr><td bgcolor=”#CC00FF”> stipe </td</tr>
    <tr><td bgcolor=”#CC00FF”> annulus </td</tr>
    <tr><td bgcolor=”#CC00FF”> gills </td</tr>
    <tr><td bgcolor=”#CC00FF”> pileus </td</tr>
    </table>
   ```

- Velocimacro arguments

    Velocimacro可以使用以下任何元素作为参数:
    - Reference:任何以$开头的 reference
    - String literal:
    - Number literal:
    - IntegerRange:[1....3]或者[$foo....$bar]
    - 对象数组:[“a”,”b”,”c”]
    - boolean 值:true、false
    当将一个reference作为参数传递给Velocimacro时，请注意reference作为参数时是以名字的形式传递的。
    这就意味着参数的值在每次Velocimacro 内执行时才会被产生。这个特性使得你可以将一个方法调用作为参数传递给 Velocimacro,
    而每次Velocimacro 执行时都是通过这个方法调用产生不同的值来执行的。
    ```
    #macro ( callme $a )
    $a $a $a
    #end
    #callme( $foo.bar() )    
    ```
- Velocimacro properties
    
    Velocity.properties 文件中的某几行能够使 Velocimacros 的实现更加灵活。
    - Velocity.properties 文件中的 velocimacro.library:一个以逗号分隔的模板库列表。
      默认情况下,velocity 查找唯一的一个库:VM_global_library.vm。你可以通过配置这个属性来指定自己的模板库。
    - Velocity.properties 文件中的 velocimacro.permissions.allow.inline 属性:
      有两个可选的值 true 或者 false,通过它可以确定 Velocimacros 是否可以被定义在regular template 内。
      默认值是 ture――允许设计者在他们自己的模板中定义Velocimacros。
    - Velocity.properties 文件中的velocimacro.permissions.allow.inline.replace.global 属性：
      有两个可选值 true 和false,这个属性允许使用者确定 inline 的 Velocimacro 定义是否可以替代全局Velocimacro定义 
      ( 比 如 在 velocimacro.library 属 性 中 指 定 的 文 件 内 定 义 的Velocimacro)。
      默认情况下,此值为 false。这样就阻止本地 Velocimacro 定义覆盖全局定义。
    - Velocity.properties 文件中的velocimacro.permissions.allow.inline.local.scale 属性：
      也是有 true 和 false 两个可选值,默认是 false。
      它的作用是用于确定你 inline 定义的 Velocimacros 是否仅仅在被定义的 template 内可见。
      换句话说,如果这个属性设置为 true,一个 inline 定义的 Velocimacros 只能在定义它的 template 内使用。
    - Velocity.properties 文件中的 velocimacro.context.localscope 属性：
      有true 和false 两个可选值,默认值为 false。
      当设置为 true 时,任何在 Velocimacro 内通过#set()对 context 的修改被认为是针对此 velocimacro 的本地设置,而不会永久的影响内容。
    - Velocity.properties 文 件 中 的 velocimacro.library.autoreload属性控制Velocimacro 库的自动加载。默认是 false。
      当设置为 ture 时,对于一个 Velocimacro的调用将自动检查原始库是否发生了变化,如果变化将重新加载它。
      这个属性使得你可以不用重新启动 servlet 容器而达到重新加载的效果,就像你使用 regular 模板一样。
      这个属性可以使用的前提就是resource loader缓存是off状态(file.resource.loader.cache = false)。
    
- Velocity Trivia

    Velocimacro必须被定义在他们被使用之前。也就是说,你的#macro()声明应该出现在使用Velocimacros之前。
    特别要注意的是,如果你试图#parse()一个包含#macro()的模板。
    因为#parse()发生在运行期,但是解析器在parsetiem 决定一个看似VM元素的元素是否是一个VM元素,这样#parse()-ing 一组VM声明将不按照预期的样子工作。
    为了得到预期的结果,只需要你简单的使用velocimacro.library使得Velocity在启动时加载你的VMs。

## Escaping VTL directives
VTL directives can be escaped with “\”号,使用方式跟 VTL 的 reference 使用逃逸符的格式差不多。
    
## Range Operator
Range operator 可以被用于与#set 和#foreach statement 联合使用。
对于处理一个整型数组它是很有用的,Range operator 具有以下构造形式:
    [n..m]
m 和 n 都必须是整型,而m是否大于n则无关紧要。
**注意:** range operator 只在#set和#foreach中有效。

## Advanced Issue:Escaping and!
当一个 reference 被“!”分隔时,并且在它之前有逃逸符时,reference 将以特殊的方式处理。注意这种方式与标准的逃逸方式时不同的。
对照如下:
`#set ( $foo = “bar” )`

|    特殊形式      |                     |   标准格式    |            |
| :-------------: | :-----------------: | :----------: |------------|
|    Render 前    |      Render 后       |  Render 前   | Render 后   |
|     $\!foo      |       $!foo         |    \$foo     |    \$foo    |
|     $\!{foo}    |       $!{foo}       |    \$!foo    |    \$!foo   |
|     $\\!foo     |       $\!foo        |    \$!{foo}  |    \$!{foo} |
|     $\\\!foo    |       $\\!foo       |    \\$!{foo} |    \bar     |
