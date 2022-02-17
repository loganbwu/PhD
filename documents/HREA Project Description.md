# Estimating Individual COVID-19 Reproduction Numbers From Data

<!-- From [ERM Applications](https://au.forms.ethicalreviewmanager.com/Personalisation/DisplayPage/9) -->

## Summary

Tracking the growth of an epidemic is an important part of infection management, control, and prevention. A common population-level metric for characterising growth is the effective reproduction number (R<sub>eff</sub>), or the average number of people who are infected by each case. When R<sub>eff</sub> is above 1, the epidemic is growing. When it is equal to 1 the epidemic is stable, and when it is below 1 the epidemic is shrinking. However, R<sub>eff</sub> is a population-level measure and cannot be disaggregated by sub-populations once calculated.

This research will apply novel computational methods developed for malaria surveillance to the Victorian COVID-19 contact tracing database. These methods calculate estimates for the case-level reproduction number R<sub>c</sub>, which is a statistical estimate unique to each case. By assigning a metric to each COVID-19 case, these methods will allow operators to analyse epidemic growth by subregion (e.g., suburb) and over time, identifying potential hot-spots and populations. A byproduct of developing these methods will be the identification of important variables (e.g., location, genomic clustering to rule out transmission, symptom onset) that are necessary to main this ability in an operational setting.

Victorian medical data is necessary for this research. In light of the sensitivity of the raw data as held by the Department of Health and recent ethics findings from the Victorian Ombudsman: (a) Logan Wu will work with the Department of Health to deidentify the dataset in a reproducible manner to mitigate privacy concerns, and (b) any ethical concerns that arise during the course of this research will be raised with the WEHI HREC.

---

## Project teams roles & responsibilities

- Logan Wu<sup>1, 2, 3</sup> — PhD student, wu.l@wehi.edu.au
- Dr. Eamon Conway<sup>1</sup> — Postdoctoral research fellow, conway.e@wehi.edu.au
- Prof. Ivo Mueller<sup>1, 2</sup> — Principal supervisor, mueller@wehi.edu.au
- Prof. Jodie McVernon<sup>2</sup> — Co-supervisor, j.mcvernon@unimelb.edu.au
- Prof. James McCaw <sup>2</sup> — Co-supervisor, jamesm@unimelb.edu.au

1. WEHI
2. University of Melbourne
3. Victorian Department of Health

---

## Resources

Resources required for this research:

- Linelist of all confirmed Victorian COVID-19 cases, including:
  - Case number, cryptographically hashed so it cannot be re-identified by anyone with access to the Department of Health's original COVID-19 database
  - Residential address, also obfuscated by hashing
  - Coordinates of SA1 (Australian Bureau of Statistics Statistical Area level 1) - these are similar to postcode but smaller.
  - Genomic cluster (hierarchical clustering)
  - Medical information (e.g. age in 5 year bins, calculated onset date, date notified, date symptomatic, date isolated where available)

**Note:** cryptographic hashing is a method of recoding values so the original value cannot be determined. A simplified version would be 'Address A' maps to 'ABC123' or CaseNumber 000001 maps to 'DEF456', in such a way that we can tell that two people at 'ABC123' lived together, but we do not know what their actual address is. LW can supply code to DH to do this so that LW does not receive the original address.

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

Tracking the growth of an epidemic is an important part of infection management, control, and prevention. Estimates for the effective reproduction number, R<sub>eff</sub>, are a tool to indicate whether an epidemic is controlled or uncontrolled, and whether control strategies need to be changed. However, in low transmission scenarios, R<sub>eff</sub> is highly influenced by uncertainty from imported cases. It is also a population-level measure that is not applicable to individuals and cannot be disaggregated by sub-populations once calculated. A limitation of using R<sub>eff</sub> can be seen in the spatial analysis of South Korea in 2020<sup>1</sup>, where analysis of reproduction rates is reported by province or by cluster/outbreak; a sub-province or cross-province analysis (independent of provincial boundaries) is not possible.

An alternative metric and method for analysing disease spread is presented in the NetRate algorithm<sup>2</sup>. NetRate models the hidden diffusion of disease at an individual level. Gomez-Rodriguez et al. use serial interval distributions to produce a maximum-likelihood-estimate of the true transmission network. To our knowledge, this algorithm has not been used in the local COVID-19 response in Victoria.

Routledge et al. extend the NetRate algorithm for the transmission network of malaria within a community<sup>3</sup> by allowing infections to be imported from unobserved individuals with a user-chosen likelihood threshold. This network estimates of the number of downstream cases per case (the case reproductive number R<sub>c</sub>), which can be analysed for spatial and temporal trends. Outputs include maps of R<sub>c</sub> estimates that also differentiate between local and imported transmission - an important capability when disease incidence is comparatively high in a neighbouring jurisdiction. These R<sub>c</sub> maps are also used to create short-term forecasts<sup>4</sup> for areas at a greater granularity than the overall study area, something that is not possible with the R<sub>eff</sub>.

**References**

1. M. Shim et al., *Spatial variability in reproduction number and doubling time across two waves of the COVID-19 pandemic in South Korea, February to July, 2020*, 2020.
2. M. Gomez-Rodriguez et al., *Uncovering the Temporal Dynamics of Diffusion Networks*, 2011.
3. I. Routledge et al., *Estimating spatiotemporally varying malaria reproduction numbers in a near elimination setting*, 2018.
4. I. Routledge et al., *Tracking progress towards malaria elimination in China*, 2020.

### Rationale

Estimates of the reproductive number for infectious disease are used in health surveillance systems to monitor the growth or reduction of a disease in a population. When sufficient resources are available, e.g., contact tracing for COVID-19 before elimination in November 2020, case interviews can be used to reconstruct the transmission network. However, when resources are insufficient, e.g., for other communicable diseases or for insufficiently resourced authorities outside of Victoria, approximate methods can be used.

Using techniques derived from the reconstruction of social media and malaria transmission networks, we will develop methods to estimate case-level reproductive numbers that vary throughout space and time. These can be plotted in space to identify epidemic hot-spots, and/or over time to identify trends. Spatial maps derived from these estimates can alert health authorities to concerning trends at a more granular spatial resolution than the typical R<sub>eff</sub>, and assess targeted interventions independently from administrative boundaries (e.g. local government area or public health unit catchment). The potential to estimate the status of an epidemic at the person-level allows for more focused interventions, reducing the economic burden on the public from unnecessary restrictions.

The outputs of this research align with the COVID-19 response's objectives as a piece of reusable software that could be implemented on the Department's own computer infrastructure and live COVID surveillance database. This augments the original purpose of collecting the data, to manage public health in the pandemic, by providing more specific spatial and temporal intelligence about the spread of the disease to target public health actions.

### Research questions

1. Current R<sub>eff</sub> estimates are produced for all-of-state, or internally, at the local public health unit catchment. How granular can inference be made about local transmission rates by using case-level R<sub>c</sub> estimates instead?
2. Can the inclusion of genomic clustering, household membership and geographic distance improve the accuracy of the adapted NetRate algorithm?
3. Is our adapted method reliable enough to feed into operational reporting for the Department of Health or similar organisations? What is required to reliably identify hotspots, e.g. is 100% genomic sequencing coverage for hierarchical clustering necessary?

### Expected outcomes

1. The production of R<sub>c</sub> maps will allow high-transmission geographies to be identified - these can validate or reinforce preparations for future epidemic responses.
2. We will compare our recreated transmission maps against other algorithms to show changes in statistical performance due to our modifications.

---

## Project Design

### Research project setting

This research is entirely computational and dry lab-based. There will be no contact with participants (COVID-19 cases).

### Methodological approach

The methodology for this research is similar to previous research conducted for other jurisdictions' datasets. By using an existing, operational dataset, it aims to develop methods that can support future operations.

### Participants

There will be at least 125,000 confirmed COVID-19 patients in the linelist from between February 2020 to the current date. Patients will not be contacted or identifiable. This is almost guaranteed to contain individuals with sensitive settings (e.g., pregnancy, criminal records, etc) but this is incidental by virtue of being a COVID-19 patient in Victoria, and these sensitive details will not be received or used.

Consent will not be sought individually due to the retrospective nature of this research and the need for a full dataset. No personally identifiable information will be received or used.

### Research activities

No interaction is required from COVID-19 patients. Experiments are computational in nature only.

### Data collection

Data on COVID-19 cases and outbreaks have been collected by the Victorian Department of Health on their disease surveillance systems (PHESS in 2020; TREVI since January 2021). No further data collection will occur as part of this research.

Consent for use will not be obtained because:

- Obtaining retrospective consent is not practical for this number of people.
- Data will be received and handled so that individuals cannot be identified. Attributes included are low-risk
- The primary use of the data (for Vic DH) is for disease surveillance. The results of this research will also contribute to disease surveillance, potentially also for use by Vic DH. (HPP 2a)

### Data management

<!-- *TODO: Include a data management plan in accordance with [National Statement](https://www.nhmrc.gov.au/about-us/publications/national-statement-ethical-conduct-human-research-2007-updated-2018) 3.1.45 and 3.1.56* -->

<!-- For all research, researchers should develop a data management plan that addresses their intentions related to generation, collection, access, use, analysis, disclosure, storage, retention, disposal, sharing and re-use of data and information, the risks associated with these activities and any strategies for minimising those risks. The plan should be developed as early as possible in the research process and should include, but not be limited to, details regarding:

(a) physical, network, system security and any other technological
security measures;
(b) policies and procedures;
(c) contractual and licensing arrangements and confidentiality agreements;
(d) training for members of the project team and others, as appropriate;
(e) the form in which the data or information will be stored;
(f) the purposes for which the data or information will be used and/or disclosed;
(g) the conditions under which access to the data or information may be granted to others; and
(h) what information from the data management plan, if any, needs to be communicated to potential participants.

The security arrangements specified in the data management plan should be proportional to the risks of the research project and the sensitivity of the information. -->

**Data collection and generation:** The only collected data will be that requested and supplied by the Victorian Department of Health. This will not include identifiable data; for example, address obfuscation and replacing individual coordinates with SA1 coordinates will be done by the Department of Health (but Logan Wu can assist with writing the code). Data generated by this proposed research will not contain any personally identifiable information or otherwise sensitive information.

**Storage and security:** The datasets will be transferred to the researcher(s) using the Department of Health's secure SharePoint storage; after they have been received, the Department of Health can delete the one-off request. The researcher(s) will only store data on password-protected, WEHI-administered machines. If data transfer between researchers is required, we will use the University of Melbourne's secure MediaFlux service. Data will be retained until the end of the research project. Confidential and identifiable data will not be published - any publications will only include aggregated, unidentifiable results.

Individual coordinates will be aggregated (adjusted) to the SA1 centroid, which is shared by 200-400 people. Street address will be recoded to obfuscated values (using a cryptographic ‘salting’ and ‘hashing’ technique. A simplification of this is '1 Main St' becomes 'A', '2/3 Oak Street' becomes 'B', in such a way so that the obfuscation cannot be reversed). The same process with by applied to the CaseNumber variable so that anyone with access to the provided data AND the original Department of Health database cannot link the two (so the data is not re-identifiable).

There are no labelling or protective marking requirements.

**Sharing and disclosure:** Individual-level data will not be shared outside the project team. Any members that access the data must do so on a WEHI or Department of Health-administered machine, and access must be for this research project.

**Publication:** Public results will only include elements that are not personally identifiable. Examples include aggregated tables and maps by Local Government Area or maps by Australian Bureau of Statistics (ABS) statistical area(s).

### Data analysis

The data will be used for fitting and calibrating disease transmission models, as real observations from an unknown infection process. The data are not treated as experimental outcomes as in a clinical trial; instead, the calibrated model will be used to generate non-confidential, synthetic outcomes. These synthetic outcomes will be used to evaluate the performance of different models and simulated interventions.

### Data linkage

Data will not be linked in a way such that individuals could be identified. Data may be linked against aggregate-level, publicly available data, such as Facebook mobility data (a population-level index showing aggregated regional travel, which could contribute to transmission) or ABS indices by statistical area(s).

### Outcome measures

Outcome measures will be based on metrics derived from the algorithms under development, not statistics derived for clinical outcomes of Victorian COVID-19 patients.

Examples of measures we can use include AIC (the Akaike information criterion), which represents how well the model fits to the provided data. Because disease transmission can be simulated, it is also common create a synthetic population with a known *true* transmission tree between people, and compare the estimated tree from the algorithm against the true tree; the percent accuracy (or other performance measures) can be fairly compared between versions of the algorithm, or different algorithms.

---

## Results, outcomes and future plans

### Plans for return of results of research to participants

Results will not be returned to participants due to the scale and no clinical benefit to individuals post-infection.

### Plans for dissemination and publication

It is intended to publish one or more papers on the performance of new or modified algorithms when applied to the Victorian COVID-19 datasets. These papers will not be about COVID-19 as a disease or the Victorian cases; rather, they will be about the algorithms using the Victorian data as a case study.

### Other potential uses of the data at the end of the project

These data will not be retained.

### Project closure processes

Minimal project closure is required for this data-only study. Data will be deleted and source code (without data) will be publicly uploaded to a server such as GitHub.

### Plans for sharing and/or future use of data and/or follow-up research

Follow-up research will require another project, especially if more detailed/sensitive linelist attributes are needed.
