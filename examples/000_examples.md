# Examples

## 1xx: 単一材料のバンド計算

| Script | Model | Source | Material |
| ------ | ----- | ------ | -------- |
| `101_GaAs_sp3sstar.jl` | SP3Sstar | Vogl1983 | GaAs |
| `102_Si_sp3sstar.jl` | SP3Sstar | Vogl1983 | Si |
| `103_GaAs_sp3d5sstar.jl` | SP3D5Sstar | Jancu1998 | GaAs |
| `104_GaAs_sp3sstar_so.jl` | SP3Sstar_SO | Vogl1983 | GaAs |

## 2xx: 比較（モデル間・ソース間）

| Script | 比較内容 |
| ------ | -------- |
| `201_GaAs_sp3_vs_sp3sstar.jl` | SP3 vs SP3Sstar (Vogl 1983) |
| `202_Si_3models.jl` | SP3 / SP3Sstar / SP3D5Sstar |
| `203_GaAs_vogl_vs_klimeck.jl` | Vogl1983 vs Klimeck2000 |

## 3xx: 出版用図（PythonPlot / matplotlib）

| Script | 出力 |
| ------ | ---- |
| `301_GaAs_sp3sstar_publication.jl` | `301_GaAs_sp3sstar_publication.pdf` |
| `302_GaAs_sp3_vs_sp3sstar_publication.jl` | `302_..._publication.pdf`, `302_..._overlay.pdf` |

## 実行方法

```julia
include("examples/101_GaAs_sp3sstar.jl")
```

出力画像（`.png` / `.pdf`）は `.gitignore` で除外されています。
