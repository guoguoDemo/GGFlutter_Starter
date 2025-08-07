# lib 目录说明

- **models/**：数据模型定义，建议每个 model 单独一个文件。
- **providers/**：状态管理（如 Provider、ChangeNotifier），建议每个 provider 单独一个文件。
- **services/**：业务服务/网络请求封装。
- **utils/**：工具类、通用方法。
- **widgets/**：自定义组件。
- **screens/**：页面（Screen/View），建议每个页面单独一个文件夹。
- **l10n/**：国际化资源（如 arb 文件）。
- **config/**：全局配置（如环境变量、常量等）。
- **constants/**：常量定义。
- **routes/**：路由管理相关代码。
- **repository/**：数据仓库层，负责数据获取与缓存。

> 本模板已集成：主题切换、国际化、路由管理、Provider 状态管理、dio 网络请求、logger 日志工具等常用功能。

建议：每个目录下都放置 README.md 说明用途。