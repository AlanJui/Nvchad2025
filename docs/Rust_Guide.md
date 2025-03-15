# Rust 作業環境建置指引

## 下戴

- 官網： [https://www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install)
- 下戴[RUSTUP-INIT.EXE (64-bit)](https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe)

【註】： WSL2 (Windows Subsystem for Linux)

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## 安裝

```sh
The Cargo home directory is located at:

  C:\Users\AlanJui\.cargo

This can be modified with the CARGO_HOME environment variable.

The cargo, rustc, rustup and other commands will be added to
Cargo's bin directory, located at:

  C:\Users\AlanJui\.cargo\bin

This path will then be added to your PATH environment variable by
modifying the HKEY_CURRENT_USER/Environment/PATH registry key.

You can uninstall at any time with rustup self uninstall and
these changes will be reverted.

Current installation options:


   default host triple: x86_64-pc-windows-msvc
     default toolchain: stable (default)
               profile: default
  modify PATH variable: yes

1) Proceed with standard installation (default - just press enter)
2) Customize installation
3) Cancel installation
>1

info: profile set to 'default'
info: default host triple is x86_64-pc-windows-msvc
info: syncing channel updates for 'stable-x86_64-pc-windows-msvc'
info: latest update on 2025-02-20, rust version 1.85.0 (4d91de4e4 2025-02-17)
info: downloading component 'cargo'
info: downloading component 'clippy'
info: downloading component 'rust-docs'
info: downloading component 'rust-std'
info: downloading component 'rustc'
 63.8 MiB /  63.8 MiB (100 %)  55.3 MiB/s in  1s
info: downloading component 'rustfmt'
info: installing component 'cargo'
info: installing component 'clippy'
info: installing component 'rust-docs'
 18.3 MiB /  18.3 MiB (100 %)   1.2 MiB/s in  8s
info: installing component 'rust-std'
 22.3 MiB /  22.3 MiB (100 %)  18.1 MiB/s in  1s
info: installing component 'rustc'
 63.8 MiB /  63.8 MiB (100 %)  18.8 MiB/s in  3s
info: installing component 'rustfmt'
info: default toolchain set to 'stable-x86_64-pc-windows-msvc'

  stable-x86_64-pc-windows-msvc installed - rustc 1.85.0 (4d91de4e4 2025-02-17)


Rust is installed now. Great!

To get started you may need to restart your current shell.
This would reload its PATH environment variable to include
Cargo's bin directory (%USERPROFILE%\.cargo\bin).

Press the Enter key to continue.
```

上述安裝作業，將執行檔置入路徑： ~\AppData\.cargo\bin ；
同時，安裝程式亦更新了系統環境變數 Path 。故需先重啟
Windows 終端機，才能使 rust 與 cargo 正常運作。

```sh
(.venv) PS C:\work\Piau-Im> ls C:\Users\AlanJui\.cargo\


    Directory: C:\Users\AlanJui\.cargo


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         2025/3/15  下午 07:50                bin


(.venv) PS C:\work\Piau-Im> ls C:\Users\AlanJui\.cargo\bin


    Directory: C:\Users\AlanJui\.cargo\bin


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         2025/3/15  下午 07:42       12568064 cargo-clippy.exe
-a----         2025/3/15  下午 07:42       12568064 cargo-fmt.exe
-a----         2025/3/15  下午 07:42       12568064 cargo-miri.exe
-a----         2025/3/15  下午 07:42       12568064 cargo.exe

-a----         2025/3/15  下午 07:42       12568064 clippy-driver.exe

-a----         2025/3/15  下午 07:42       12568064 rls.exe

-a----         2025/3/15  下午 07:42       12568064 rust-analyzer.exe

-a----         2025/3/15  下午 07:42       12568064 rust-gdb.exe

-a----         2025/3/15  下午 07:42       12568064 rust-gdbgui.exe

-a----         2025/3/15  下午 07:42       12568064 rust-lldb.exe

-a----         2025/3/15  下午 07:42       12568064 rustc.exe

-a----         2025/3/15  下午 07:42       12568064 rustdoc.exe

-a----         2025/3/15  下午 07:42       12568064 rustfmt.exe

-a----         2025/3/15  下午 07:42       12568064 rustup.exe
```

## 驗證安裝結果

依據官網之[《The Cargo Book》](https://doc.rust-lang.org/cargo/getting-started/first-steps.html) 指引文件，
實作一 Hello World 專案，用以驗證 Rust 之安裝結果，已能正常運作，完成 Build 編譯原始碼作業；並可産出執行檔及
能執行。

### 建立 Rust 工作目錄

```sh
cd \work\
mkdir rust ; cd rust
```

### 建立專案目錄

```sh
$ cargo new hello_world
$ cd hello_world
$ tree .
.
├── Cargo.toml
└── src
    └── main.rs

1 directory, 2 files
```

### 查檢專案套件設定檔

Cargo.toml

```sh
[package]
name = "hello_world"
version = "0.1.0"
edition = "2024"

[dependencies]
```

### 查檢原始程式碼

```sh
fn main() {
    println!("Hello, world!");
}
```

### 編譯（Build）原始程式碼

```sh
$ cargo build
   Compiling hello_world v0.1.0 (file:///path/to/package/hello_world)
```

### 執行二進位檔案

```sh
$ .\target\debug\hello_world
Hello, world!
```

或使用 cargo 的 run 指令

```sh
$ cargo run
     Fresh hello_world v0.1.0 (file:///path/to/package/hello_world)
   Running `target/hello_world`
Hello, world!
```
