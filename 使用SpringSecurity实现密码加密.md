# 使用SpringSecurity实现密码加密

BCryptPasswordEncoder相关知识：

　　用户表的密码通常使用MD5等不可逆算法加密后存储，为防止彩虹表破解更会先使用一个特定的字符串（如域名）加密，然后再使用一个随机的salt（盐值）加密。

　　特定字符串是程序代码中固定的，salt是每个密码单独随机，一般给用户表加一个字段单独存储，比较麻烦。

　　BCrypt算法将salt随机并混入最终加密后的密码，验证时也无需单独提供之前的salt，从而无需单独处理salt问题。

2、BCryptPasswordEncoder 是在哪里使用的？

（1）登录时用到了 DaoAuthenticationProvider

　　它有一个方法 additionalAuthenticationChecks(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication)，此方法用来校验从数据库取得的用户信息和用户输入的信息是否匹配。

（2）在注册时，需要对用户密码加密

　　应用 BCryptPasswordEncoder 之后，明文密码是无法被识别的，就会校验失败，只有存入密文密码才能被正常识别。所以，应该在注册时对用户密码进行加密。

```java
private String encryptPassword(String password) {
    // BCryptPasswordEncoder 加密
    return new BCryptPasswordEncoder().encode(password);
}
```

