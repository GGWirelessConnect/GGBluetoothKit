
#ifndef GGEnumMarcos_h
#define GGEnumMarcos_h

#define ENUM_VALUE(name, assign) name assign,

#define ENUM_CASE(name, assign) case name: return @#name;

#define ENUM_STRCMP(name, assign) if ([string isEqualToString:@#name]) return name;


#define DECLARE_ENUM(EnumType, ENUM_DEF) \
typedef NS_ENUM(NSInteger, EnumType) { \
ENUM_DEF(ENUM_VALUE) \
}; \
NSString *NSStringFrom##EnumType(EnumType value); \
EnumType EnumType##FromNSString(NSString *string); \

// define
#define DEFINE_ENUM(EnumType, ENUM_DEF) \
NSString *NSStringFrom##EnumType(EnumType x) \
{ \
switch(x) \
{ \
ENUM_DEF(ENUM_CASE) \
default: return @""; \
} \
} \
EnumType EnumType##FromNSString(NSString *string) \
{ \
ENUM_DEF(ENUM_STRCMP) \
return (EnumType)0; \
}


#endif /* GGEnumMarcos_h */
