1. 定义自定义注解MyAnnotation，其中value属性可以设置为String类型：

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface MyAnnotation {
    String value() default "";
}
```

1. 在需要加注解的方法doSuccessUpdateSpot上添加@MyAnnotation注解，并使用SPEL表达式将方法参数uid的值传给注解的value属性：

```java
@MyAnnotation("#{uid}")
public long doSuccessUpdateSpot(String uid) {
    // 方法体
}
```

1. 在MyAnnotation注解的value属性中，使用SPEL表达式的占位符#{uid}来表示方法参数uid的值，并将其设置为注解的value属性：

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface MyAnnotation {
    String value() default "#{''}";
}
```

1. 在Spring配置文件中配置一个PropertySourcesPlaceholderConfigurer bean，用于解析SPEL表达式：

```xml
<bean class="org.springframework.context.support.PropertySourcesPlaceholderConfigurer" />
```

1. 在MyAnnotationAspect切面类中，获取注解的value属性，并使用SPEL表达式解析方法参数uid的值，并将其设置为注解的value属性：

```java
@Aspect
@Component
public class MyAnnotationAspect {

    @Around("@annotation(com.example.MyAnnotation)")
    public Object around(ProceedingJoinPoint pjp) throws Throwable {
        MethodSignature signature = (MethodSignature) pjp.getSignature();
        Method method = signature.getMethod();
        MyAnnotation myAnnotation = method.getAnnotation(MyAnnotation.class);
        String value = myAnnotation.value(); // 获取注解的value属性
        if (StringUtils.isNotBlank(value) && value.contains("#{")) { // 判断value属性是否包含SPEL表达式
            String uid = (String) pjp.getArgs()[0]; // 获取方法参数的值
            value = StringUtils.replace(value, "#{uid}", uid); // 使用SPEL表达式解析方法参数的值
            myAnnotation.value(value); // 将解析后的值设置为注解的value属性
        }
        return pjp.proceed();
    }
}
```

这样，在方法执行时，就会自动触发切面类中的around方法，在方法执行前或执行后，通过SPEL表达式解析方法参数的值，并将其设置为注解的value属性。



----

在Java中，获取方法参数的名称是比较困难的，因为在编译时，方法参数的名称会被编译器优化掉，而只保留参数的类型信息。

不过，可以使用第三方库或者工具来获取方法参数的名称，比如Spring的ParameterNameDiscoverer接口，它可以通过反射获取方法参数的名称。

具体实现步骤如下：

1. 在Spring配置文件中配置一个DefaultParameterNameDiscoverer bean，用于获取方法参数的名称：

```xml
<bean id="parameterNameDiscoverer" class="org.springframework.core.DefaultParameterNameDiscoverer" />
```

1. 在MyAnnotationAspect切面类中，注入ParameterNameDiscoverer bean，并使用它来获取方法参数的名称：

```java
@Aspect
@Component
public class MyAnnotationAspect {

    @Autowired
    private ParameterNameDiscoverer parameterNameDiscoverer;

    @Around("@annotation(com.example.MyAnnotation)")
    public Object around(ProceedingJoinPoint pjp) throws Throwable {
        MethodSignature signature = (MethodSignature) pjp.getSignature();
        Method method = signature.getMethod();
        MyAnnotation myAnnotation = method.getAnnotation(MyAnnotation.class);
        String value = myAnnotation.value(); // 获取注解的value属性
        if (StringUtils.isNotBlank(value) && value.contains("#{")) { // 判断value属性是否包含SPEL表达式
            String[] parameterNames = parameterNameDiscoverer.getParameterNames(method); // 获取方法参数的名称
            String uid = (String) pjp.getArgs()[0]; // 获取方法参数的值
            for (int i = 0; i < parameterNames.length; i++) {
                String parameterName = parameterNames[i];
                if ("uid".equals(parameterName)) { // 判断参数名称是否为uid
                    value = StringUtils.replace(value, "#{" + parameterName + "}", uid); // 使用SPEL表达式解析方法参数的值
                    break;
                }
            }
            myAnnotation.value(value); // 将解析后的值设置为注解的value属性
        }
        return pjp.proceed();
    }
}
```

这样，在方法执行时，就会自动触发切面类中的around方法，在方法执行前或执行后，通过ParameterNameDiscoverer接口获取方法参数的名称，并使用SPEL表达式解析方法参数的值，并将其设置为注解的value属性。