# ESP Batch Visualization Script

# ESP 批量可视化脚本

---

## Citation / 引用（Placeholder）

> **[PLACEHOLDER] Citation information will be added here once the related paper is published.**
> Before publication, you may cite this repository or omit citation according to journal policy.
>
> **[占位] 论文发表后将在此处补充正式引用信息。**
> 在论文正式发表前，可引用本仓库或按期刊政策处理。

---

## Purpose / 脚本用途

### English

This script provides a **batch ESP surface visualization workflow** based on **VMD**, designed for:

* Consistent ESP rendering
* Automatic colorbar generation
* Grouped rendering and export
* Post-processing into publication-ready figures

### 中文

本脚本用于 **基于 VMD 的 ESP 批量可视化**，目标包括：

* ESP 渲染方式统一
* 自动生成 colorbar
* 分组渲染与导出
* 生成可直接用于论文的最终图像

---

## Prerequisites / 前置条件

### Software Requirements / 软件要求

* **Multiwfn**：用于预先生成 ESP 相关 PDB 文件
* **VMD**：用于 ESP 渲染与批量导出
* **Adobe Photoshop (> 2022)**：用于最终图像叠加与合成

---

## Step 1: Prepare PDB Files with Multiwfn

## 第一步：使用 Multiwfn 准备 PDB 文件

### English

All required **PDB files must be generated in advance using Multiwfn**.

1. Use **Multiwfn** to calculate ESP.
2. Export the following PDB files:

   * Molecular structure
   * ESP surface
   * ESP surface vertices
   * *(Optional)* surface analysis data
3. Copy **all generated PDB files into the VMD directory**.

#### Required Naming Convention

PDB files must follow this naming scheme:

* `mol*.pdb` → molecular structure
* `vtx*.pdb` → ESP surface vertices
* `surfanalysis*.pdb` → surface analysis data *(optional)*

The index `*` must match across files belonging to the same system.

### 中文

**所有 PDB 文件必须提前由 Multiwfn 生成完成**。

1. 使用 **Multiwfn** 计算 ESP。
2. 导出以下 PDB 文件：

   * 分子结构
   * ESP 表面
   * ESP 表面顶点
   * （可选）表面分析数据
3. 将 **所有生成的 PDB 文件复制到 VMD 文件夹中**。

#### 命名规则（必须遵守）

PDB 文件需满足以下命名方式：

* `mol*.pdb` → 分子结构
* `vtx*.pdb` → ESP 表面顶点
* `surfanalysis*.pdb` → 表面分析数据（可选）

其中 `*` 为编号，同一体系的文件编号必须一致。

---

## Step 2: VMD Script Installation

## 第二步：VMD 脚本安装

### English

1. Copy the following scripts into the **VMD directory**:

   * `ESPbatch.vmd`
   * `colorbar.tcl`
2. Edit `vmd.rc` and add:

```tcl
proc ESPbatch {} {source ESPbatch.vmd}
```

> `colorbar.tcl` will be sourced automatically by `ESPbatch.vmd`.

### 中文

1. 将以下脚本复制到 **VMD 文件夹**：

   * `ESPbatch.vmd`
   * `colorbar.tcl`
2. 编辑 `vmd.rc`，加入：

```tcl
proc ESPbatch {} {source ESPbatch.vmd}
```

> `colorbar.tcl` 将由 `ESPbatch.vmd` 自动加载。

---

## Step 3: Run ESP Batch Rendering in VMD

## 第三步：在 VMD 中运行 ESP 批量渲染

### English

1. Launch **VMD**.
2. In the **VMD Tk Console**, type:

```text
ESPbatch
```

3. The script will:

   * Automatically load PDB files based on naming convention
   * Render ESP surfaces following **[PLACEHOLDER: ESP rendering scheme]**
   * Automatically generate and place the colorbar
   * Perform **grouped rendering and export** for all detected systems

### 中文

1. 启动 **VMD**。
2. 在 **VMD Tk Console** 中输入：

```text
ESPbatch
```

3. 脚本将自动执行：

   * 按命名规则加载所有 PDB 文件
   * 按 **【占位：ESP 渲染方案说明】** 进行 ESP 绘制
   * 自动生成并添加 colorbar
   * 对所有体系进行 **分组渲染与导出**

---

## Step 4: Final Image Composition (Photoshop)

## 第四步：最终图像合成（Photoshop）

### English

1. Open **Adobe Photoshop (version > 2022)**.
2. Run the `stack_esp` script.
3. Select:

   * Input folder (VMD exported images)
   * Output folder
4. The script will automatically stack layers and export final images.

### 中文

1. 打开 **Adobe Photoshop（版本 > 2022）**。
2. 运行 `stack_esp` 脚本。
3. 选择：

   * 输入文件夹（VMD 导出的图像）
   * 输出文件夹
4. 脚本将自动完成图层叠加并导出最终图片。

---

## Output / 输出结果

* Final images suitable for publication figures
* Consistent ESP color mapping and layout across systems

---

* 输出结果可直接用于论文插图
* 不同体系之间 ESP 配色与布局保持一致

---

## Notes / 备注

* All ESP rendering parameters are controlled in `ESPbatch.vmd`
* `surfanalysis*.pdb` is optional and will be ignored if absent
* Paths should avoid whitespace and special characters

---

* 所有 ESP 渲染参数均在 `ESPbatch.vmd` 中控制
* `surfanalysis*.pdb` 为可选文件，不存在时脚本会自动跳过
* 建议避免路径中包含空格或特殊字符
