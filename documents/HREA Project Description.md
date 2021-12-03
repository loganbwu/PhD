# Estimating Individual COVID-19 Reproduction Numbers From Data

From [ERM Applications](https://au.forms.ethicalreviewmanager.com/Personalisation/DisplayPage/9)

---

## Project teams roles & responsibilities

- Logan Wu<sup>1, 2, 3</sup> — PhD student, wu.l@wehi.edu.au
- Eamon Conway<sup>1</sup> — Postdoctoral research fellow, conway.e@wehi.edu.au
- Ivo Mueller<sup>1, 2</sup> — Lab head & professor, mueller@wehi.edu.au

1. WEHI
2. University of Melbourne
3. Victorian Department of Health

---

## Resources

Resources required for this research:

- Linelist of all confirmed Victorian COVID-19 cases, including:
  - Case number
  - Calculated onset date
  - Residential address (with opportunity to obfuscate)
  - Coordinates (either at address or aggregated, e.g. at SA1)
  - Genomic cluster
  - Basic demographic information (e.g. age, date notified)
  - Any connected outbreaks (in separate table)

- Case links
  - Source and target case numbers
  - Relationship, when available

- Outbreaks
  - Outbreak declared date
  - Industry

Data are requested in tabular (CSV) form.

---

## Background

### Literature review

Tracking the growth of an epidemic is an important part of infection management, control, and prevention. Estimates for the effective reproduction number, R<sub>eff</sub>, are a tool to indicate whether an epidemic is controlled or uncontrolled, and whether control strategies need to be changed. However, in low transmission scenarios, R<sub>eff</sub> is highly influenced by uncertainty from imported cases. It is also a population-level measure that is not applicable to individuals and cannot be disaggregated by sub-populations once calculated.

An alternative metric and method for analysing disease spread is presented in the NetRate algorithm<sup>1</sup>. NetRate models the unknown diffusion of information (such as social media posts) or disease at an individual level. Gomez-Rodriguez et al. use serial interval distributions to produce a maximum-likelihood-estimate of the true transmission network.

Routledge et al. extend the NetRate algorithm for the transmission network of malaria within a community<sup>2</sup> by allowing infections to be imported from unobserved individuals with a user-chosen likelihood threshold. This network estimates of the number of downstream cases per case (the case reproductive number R<sub>c</sub>), which can be analysed for spatial and temporal trends. Outputs include maps of R<sub>c</sub> estimates that also differentiate between local and imported transmission - an important capability when disease incidence is comparatively high in a neighbouring jurisdiction. These R<sub>c</sub> maps are also used to create short-term forecasts<sup>3</sup> for areas at a greater granularity than the overall study area, something that is not possible with the R<sub>eff</sub>.

**References**

1. M. Gomez-Rodriguez et al., *Uncovering the Temporal Dynamics of Diffusion Networks*, 2011.
2. I. Routledge et al., *Estimating spatiotemporally varying malaria reproduction numbers in a near elimination setting*, 2018.
3. I. Routledge et al., *Tracking progress towards malaria elimination in China*, 2020.

### Rationale

Estimates of the reproductive number for infectious disease are used in health surveillance systems to monitor the growth or reduction of a disease in a population. When sufficient resources are available, e.g., contact tracing for COVID-19 before elimination in November 2020, case interviews can be used to reconstruct the transmission network. However, when resources are insufficient, e.g., for other communicable diseases or for insufficiently resourced authorities outside of Victoria, approximate methods can be used.

Using techniques derived from the reconstruction of social media and malaria transmission networks, we will develop methods to estimate case-level reproductive numbers that vary throughout space and time. These can be plotted in space to identify epidemic hot-spots, and/or over time to identify trends.

### Research questions

1. Current R<sub>eff</sub> estimates are produced for all-of-state, or internally, at the local public health unit catchment. How granular can inference be made about local transmission rates by using case-level R<sub>c</sub> estimates instead?
2. Can the inclusion of genomic sequencing, household membership and geographic distance improve the accuracy of the adapted NetRate algorithm?
3. Is our adapted method reliable enough to feed into operational reporting for the Department of Health or similar organisations?

### Expected outcomes

1. The production of R<sub>c</sub> maps will allow high-transmission geographies to be identified - these can validate or reinforce preparations for future epidemic responses.

---

## Project Design

### Research project setting

This research is entirely computational and dry lab-based. There will be no contact with participants (COVID-19 cases).

### Methodological approach

The methodology for this research is similar to previous research conducted for other jurisdictions' datasets. By using an existing, operational dataset, it aims to develop methods that can support future operations.

### Participants

There will be at least 125,000 confirmed COVID-19 patients in the linelist from between February 2020 to the current date. Patients will not be contacted or identifiable.

Consent will not be sought individually due to the retrospective nature of this research and the need for a full dataset. No personally identifiable information will be held.

### Research activities

No interaction is required from COVID-19 patients. Experiments are computational 

### Data collection

### Data management

### Data analysis

### Data linkage

### Outcome measures

---

## Results, outcomes and future plans

### Plans for return of results of research to participants

### Plans for dissemination and publication

### Other potential uses of the data at the end of the project

### Project closure processes

### Plans for sharing and/or future use of data and/or follow-up research
