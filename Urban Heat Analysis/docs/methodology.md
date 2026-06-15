# Methodology: Urban Heat Island Satellite Analysis — London, UK

## 1. Study Area

The study area encompasses the 32 London Boroughs plus the City of London, collectively administered by the Greater London Authority (GLA). Greater London covers approximately 1,572 km² and is situated in south-east England (centred at approximately 51.51° N, 0.13° W). It represents one of the most densely urbanised regions in Europe, with a population of approximately 8.9 million (2021 Census) and a land cover dominated by impervious surfaces, transport infrastructure, and low-rise residential development interspersed with parks and the River Thames corridor.

All spatial data in this project are projected to the **British National Grid (EPSG:27700)**, which provides accurate area and distance measurements for the UK context and is consistent with GLA boundary datasets.

---

## 2. Satellite Data Selection

### 2.1 Sensor Selection

Landsat 8 (launched 2013) and Landsat 9 (launched 2021) are operationally identical in terms of their Thermal Infrared Sensor (TIRS) characteristics. Both carry TIRS Band 10 (10.60–11.19 µm) at 100 m spatial resolution (resampled to 30 m in Level-2 products), making multitemporal comparison between the two sensors scientifically sound without cross-calibration corrections.

**USGS Landsat Collection 2 Level-2 Surface Temperature** products are used directly, as these have been atmospherically corrected and converted to brightness temperature (in Kelvin) as standard. This avoids the need to apply atmospheric correction algorithms from raw Digital Numbers and reduces a major source of error.

### 2.2 Scene Selection

| Parameter | 2015 Scene | 2023 Scene |
|---|---|---|
| Sensor | Landsat 8 OLI/TIRS | Landsat 9 OLI-2/TIRS-2 |
| WRS-2 Path/Row | 201 / 024 | 201 / 024 |
| Acquisition season | July–August | July–August |
| Cloud cover threshold | < 10% | < 10% |
| Collection | Collection 2, Level-2 | Collection 2, Level-2 |

Summer acquisitions (July–August) are deliberately selected to: (i) maximise solar irradiance and LST signal; (ii) ensure full leaf-out for NDVI comparability; (iii) align with the period of peak UHI intensity in temperate cities (Oke, 1982). Scenes outside this window would introduce confounding seasonal temperature variation.

Cloud masking is applied using the Landsat QA_PIXEL band, which encodes cloud, cloud shadow, and cirrus flags derived from the CFMask algorithm (Foga et al., 2017).

---

## 3. Land Surface Temperature (LST) Derivation

### 3.1 Brightness Temperature

USGS Collection 2 Level-2 ST_B10 products are delivered in scaled integer format. Conversion to brightness temperature *T_B* (in Kelvin) applies the published scale factor and offset:

```
T_B (K) = ST_B10 × 0.00341802 + 149.0
```

### 3.2 NDVI-based Emissivity Estimation

LST retrieval requires an estimate of land surface emissivity (ε). Following Sobrino et al. (2004), emissivity is estimated using the fractional vegetation cover (*F_v*) derived from NDVI:

**Fractional vegetation cover:**

```
F_v = ((NDVI - NDVI_min) / (NDVI_max - NDVI_min))²
```

where NDVI_min and NDVI_max are taken as the 2nd and 98th percentiles of the NDVI distribution across the study area to minimise the influence of outliers.

**Emissivity (ε):**

```
ε = ε_v × F_v + ε_s × (1 - F_v) + C
```

where:
- ε_v = 0.985 (emissivity of full vegetation canopy)
- ε_s = 0.960 (emissivity of bare soil / impervious surfaces)
- C = 0.005 (cavity effect term for heterogeneous surfaces)

### 3.3 LST Conversion

Land Surface Temperature is derived from brightness temperature and emissivity using the simplified Planck function inversion (Jiménez-Muñoz & Sobrino, 2003):

```
LST (K) = T_B / (1 + (λ × T_B / ρ) × ln(ε))
```

where:
- λ = 10.895 µm (effective wavelength of TIRS Band 10)
- ρ = h × c / σ = 1.438 × 10⁻² m·K (radiation constant)
  - h = Planck's constant (6.626 × 10⁻³⁴ J·s)
  - c = speed of light (2.998 × 10⁸ m/s)
  - σ = Boltzmann constant (1.380 × 10⁻²³ J/K)

Final LST values are converted to **degrees Celsius** (LST_°C = LST_K − 273.15) for interpretability.

---

## 4. Normalised Difference Vegetation Index (NDVI)

NDVI is calculated from surface reflectance bands included in the Landsat Collection 2 Level-2 SR product:

```
NDVI = (NIR - Red) / (NIR + Red)
     = (Band 5 - Band 4) / (Band 5 + Band 4)
```

Surface reflectance values are converted from their scaled integer representation using the standard scale factor (0.0000275) and offset (−0.2) prior to the calculation. NDVI values range from −1 to +1, with values above approximately 0.3 indicative of healthy vegetation in the London context.

---

## 5. Change Analysis

### 5.1 Delta LST and Delta NDVI

Pixel-wise difference rasters are computed between co-registered 2023 and 2015 outputs:

```
ΔLST = LST_2023 - LST_2015
ΔNDVI = NDVI_2023 - NDVI_2015
```

Prior to subtraction, both raster pairs are confirmed to share an identical grid (extent, resolution, CRS) via rasterio alignment; where minor misalignment exists due to sub-pixel differences in scene registration, the 2023 raster is resampled to the 2015 grid using bilinear interpolation.

### 5.2 Borough-Level Aggregation

Zonal statistics (mean LST, mean NDVI, ΔLST) are computed for each of the 33 London boroughs using rasterio's masking functionality in combination with the GLA borough boundary shapefile. The five boroughs exhibiting the highest mean ΔLST are identified as primary hotspot zones.

### 5.3 LST–NDVI Correlation

Pearson's correlation coefficient is calculated between pixel-level LST and NDVI values for each year independently, and between ΔLST and ΔNDVI across all valid pixels. Statistical significance is assessed at p < 0.05. A negative correlation is expected, reflecting the cooling effect of vegetation through evapotranspiration and shading.

---

## 6. Limitations

**Temporal inconsistency:** Although both scenes are acquired in summer, day-of-year differences, time-of-overpass differences, and inter-annual meteorological variability (antecedent soil moisture, synoptic weather patterns) introduce uncertainty into LST comparisons that cannot be fully eliminated. Ideally, multiple cloud-free scenes per season would be composited; this analysis uses single best-available scenes per epoch.

**Sensor differences:** While Landsat 8 and 9 TIRS instruments are nominally identical, minor calibration differences exist. USGS Collection 2 products apply cross-calibration corrections, but residual biases at the sub-Kelvin level are possible.

**Emissivity estimation:** The NDVI-based emissivity approach is a first-order approximation. Urban environments contain spectrally complex surfaces (glass, metal, water bodies, artificial turf) whose emissivities diverge from the soil/vegetation model assumed here. This may introduce localised errors of ±1–2°C in LST in highly heterogeneous urban cores.

**Spatial resolution:** At 30 m, individual buildings and street canyons are not resolved. Results represent sub-pixel mixtures of surface types and are more appropriate for neighbourhood- to borough-level interpretation than building-scale analysis.

**Boundary effects:** The Landsat scene footprint and the Greater London boundary do not align perfectly; pixels on the periphery of the study area may be clipped, and areas outside Greater London are masked entirely, meaning rural reference temperatures cannot be derived from this dataset alone.

---

## 7. References

- Foga, S., et al. (2017). Cloud detection algorithm comparison and validation for operational Landsat data products. *Remote Sensing of Environment*, 194, 379–390.
- Jiménez-Muñoz, J. C., & Sobrino, J. A. (2003). A generalized single-channel method for retrieving land surface temperature from remote sensing data. *Journal of Geophysical Research: Atmospheres*, 108(D22).
- Oke, T. R. (1982). The energetic basis of the urban heat island. *Quarterly Journal of the Royal Meteorological Society*, 108(455), 1–24.
- Sobrino, J. A., Jiménez-Muñoz, J. C., & Paolini, L. (2004). Land surface temperature retrieval from LANDSAT TM 5. *Remote Sensing of Environment*, 90(4), 434–440.
- USGS. (2023). *Landsat Collection 2 Level-2 Science Product Guide*. U.S. Geological Survey.
