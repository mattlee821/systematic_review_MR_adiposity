
# Systematic review: What has the application of Mendelian randomization informed us about the causal relevance of adiposity and health outcomes?

We performed a systematic review of adiposity on all health outcomes.
Adiposity was defined broadly and included body mass index, birth
weight, waist hip ratio and more terms.

## Start here

-   A compressed EndNote library (`.enlx`) and text file (`.txt`) of all
    articles included in the (i) title and abstract screening, (ii) full
    text screening, (iii) and data extraction are available in the
    [`search/`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/master/search/)
    directory.
-   PDFs of all articles included in data extraction are available in
    [`search/003_articles_included_in_data_extraction/`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/master/search/003_articles_included_in_data_extraction).
-   This work was pre-registered on
    [PROSPERO](https://www.crd.york.ac.uk/prospero/display_record.php?ID=CRD42018096684).
    A copy of the pre-registration report is available in
    [`supplement/`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/supplement/PROSPERO_registration_CRD42018096684.pdf).
-   The search strategy used for Medline, EMBASE, and bioRxiv is
    available in
    [`supplement/`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/supplement/search_strategy.pdf).
-   Data extraction was completed using a [data extraction Excel
    file](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/supplement/data_extraction.xlsx)
    and [data extraction
    manual](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/supplement/data_extraction_manual.docx).
    A list of studies assigned to each reviewer is available in
    [`analysis/article_assignments_for_data_extraction/`](https://github.com/mattlee821/systematic_review_MR_adiposity/tree/main/analysis/article_assignments_for_data_extraction).
-   After data extraction, data were checked and saved using
    [`001_data_extraction.R`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/scripts/001_data_extraction.R)
    and an `R` image
    ([`001_data_extraction.RData`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/analysis/001_data_extraction.RData))
    saved.
-   The raw data extraction file (`data_extraction.xlsx`) was converted
    to a working data file
    [`002_data.csv`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/analysis/002_data.csv)
    and all data were formatted using
    [`002_data_formatting.R`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/scripts/002_data_formatting.R).
    This included saving individual `.csv` files for each
    exposure-outcome pair,
    [`analysis/meta_analysis/manual_check/`](https://github.com/mattlee821/systematic_review_MR_adiposity/tree/main/analysis/meta_analysis/manual_check).
-   Each exposure-outcome analysis saved in each of these `.csv` files
    underwent manual review
    ([`003_data_formatting_manual_check.R`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/scripts/003_data_formatting_manual_check.R))
    to decide if exposure-outcome pairs could be included in the
    meta-analysis.
-   Inclusion in the meta-analysis was decided using
    [`meta_analysis_flowchart.pdf`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/figures/meta_analysis_flowchart.pdf).
    Decisions for each exposure-outcome analysis are given in
    [`decisions_lis.txt`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/analysis/meta_analysis/decision_list.txt).
-   Prior to meta-analysis, quality assessment of all included MR
    analyses was performed using the
    [quality\_assessment\_tool.csv](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/analysis/quality_assessment/quality_assessment_tool.csv).
    Results from the quality assessment are available in
    [`analysis/quality_assessment`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/analysis/quality_assessment)
    as `quality_assessment_results.csv`. Details of each study included
    in quality assessment are available in
    `quality_assessment_studies.csv`.
-   Data for each exposure-outcome pair included in the meta-analyses
    are available in
    [`analysis/meta_analysis/data_for_analysis/`](https://github.com/mattlee821/systematic_review_MR_adiposity/tree/main/analysis/meta_analysis/data_for_analysis).
    Meta-analysis of these data was performed using
    [`004_data_analysis.R`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/scripts/004_data_analysis.R).
    Results are available in
    [`meta_analysis_results.csv`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/analysis/meta_analysis/results/meta_analysis_results.csv).
    PDFs for each article contributing to an individual meta-analysis
    are available in
    [`analysis/meta_analysis/meta_analysed_studies/`](https://github.com/mattlee821/systematic_review_MR_adiposity/tree/main/analysis/meta_analysis/meta_analysed_studies).
-   Forest plots for each individual meta-analysis are available in
    [`figures/meta_analysis_results_figures/`](https://github.com/mattlee821/systematic_review_MR_adiposity/tree/main/figures/meta_analysis_results_figures).
    Forest plots of all continuous outcomes, as well as all binary
    outcomes, and binary outcomes split between two plots are also
    available in
    [`figures/`](https://github.com/mattlee821/systematic_review_MR_adiposity/tree/main/figures/).
-   A narrative synthesis summarising effect estimates for over 2,000 MR
    analyses was achieved using
    [`005_narrative_synthesis.R`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/scripts/005_narrative_synthesis.R).
-   Additional figures:
    [`PRISMA_flowchart.pdf`](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/figures/PRISMA_flowchart.pdf),
    [number of articles published per
    year](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/figures/articles_published_per_year.pdf),
    [study
    designs](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/figures/study_design.pdf),
    [quality assessment
    scores](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/main/figures/quality_assessment_score_distribution.pdf).
    The figure for the number of articles published per year has a
    second *Y* axis which shows the average exposure (grey) and outcome
    (red) sample sizes for each year.

## Detailed info

EMBASE and MEDLINE were searched from inception (EMBASE = 1974; MEDLINE
= 1946) until February 18th 2019 using detailed search strategies
including free text and controlled vocabulary terms. The pre-print
service bioRxiv was searched from inception (November 2013) until
February 18th 2019. However, due to the limited search functionality and
inability to include Boolean operators (‘AND’, ‘OR’, ‘NOT’) in bioRxiv
searches, a restricted search strategy using four free text terms in
four independent searches was used: ‘Mendelian randomization’,
‘Mendelian randomisation’, ‘causal inference’, and ‘causal analysis’.

The search strategy included synonyms for both adiposity and MR terms.
For adiposity measures, this was to ensure searches returned all
possible instances in which a measure of adiposity was used. For MR,
synonyms were used as the term ‘Mendelian randomization’ has only been
formalised recently and many early studies would have either been
unaware they were performing an instrumental variable analysis or would
have called the method something else.

After de-duplication, the titles and abstracts of all remaining articles
from EMBASE, MEDLINE, and bioRxiv had their titles and abstracts
screened by two independent reviewers (MAL and LJM) using Rayyan. Each
reviewer screened all articles and discrepancies at this stage were
resolved through discussion between the two reviewers. Studies from
EMBASE, MEDLINE, and bioRxiv meeting the pre-defined inclusion criteria
(see below) were combined and, in instances where the bioRxiv study had
been published and this was identified in either the EMBASE or MEDLINE
search, the bioRxiv version of the study was excluded. The full texts of
the combined study dataset had their full text screened by the two
reviewers.

For title and abstract screening and for full text screening, articles
must have met the following pre-defined inclusion criteria:

1.  Be written in English
2.  Be available in full text (or in the case of conference abstracts,
    the authors must be contactable to obtain the relevant data)
3.  Be published in a peer-reviewed journal or bioRxiv
4.  Use MR methodology to investigate the causal effect of adiposity on
    any outcome
    1.  Adiposity was considered to be any measure which aimed to assess
        the amount of adipose tissue an individual possessed
    2.  If a study focused on adiposity alongside other exposures, the
        effect of each adiposity measure will be reported separately, if
        available, and report the joint effect with these other
        exposures, if not available.
    3.  articles in which an MR approach is used but not explicitly
        called ‘Mendelian randomization’ will be included. More
        specifically, any study in which genetic variants are used as
        instrumental variables or the direct association between a
        genetic variant and outcome is employed will be eligible,
        provided it meets the other inclusion criteria.

In the first instance, data extraction was performed by nine reviewers
(see Contributions), with articles split evenly between them, using a
data extraction form and data extraction manual. One reviewer dropped
out and their articles were split evenly between MAL and CAH. Once all
articles had been reviewed, two reviewers (see contributions) extracted
data on all articles they did not review in the first instance. The same
two reviewers then checked all extracted data for discrepancies which
were resolved through a third review of individual articles.

Articles included in data extraction may contain more than one relevant
MR analysis. As such, study/studies refers to the MR analysis/analyses
within an article. The following data were extracted from each articles
studies: exposure(s), outcome(s), study design and sample
characteristics, genetic variant and instrumental variable selection, MR
methodology, sensitivity analysis, and causal estimates. Where relevant
data was not reported by the article, “Not discussed” was entered into
the data extraction form.

Once data extraction was completed, three additional columns were added
to summarise the type of outcome being studied: column 1 (“outcome”) was
used as a general categorisation of all outcomes across articles (e.g.,
the outcome “ER- breast cancer” would have the value “breast cancer”);
column 2 (“outcome info”) reported the outcome-specific information that
distinguished outcomes within categories defined in column 1 (e.g.,
column 2 would contain the value “ER-” for the same breast cancer
example); and column 3 (“outcome group”) categorised outcomes more
generally than values defined in column 1 (e.g., the breast cancer
example would be categorised as “cancer”). Outcome categories were
assigned based on prior biological knowledge and aimed to collapse the
large number of outcomes. This could be achieved differently for some
outcomes, for example smoking could go in a *respiratory* category or a
*behavioural* category. Where there were few outcomes to make a
category, they were grouped into an *other* category. This will include
outcomes such as mortality, disease counts, epigenetic marker etc.

## Quality assessment

There is currently no risk of bias tool to assess the quality of MR
articles. We adapted the quality assessment tool used by [Mamluk et al
(2020)](https://pubmed.ncbi.nlm.nih.gov/31993631/) and assessed studies
on a 3-point scale (low = 3, medium = 2, high = 1) across 12 questions.
These 12 questions included the five used by Mamluk et al., one of which
related to bias due to selection of participants, which we split into
two questions for exposures and outcomes to accommodate two-sample MR
analyses. In addition, questions for instrumental variable association,
sample overlap, whether the study performed sensitivity analyses and
whether these were biased, descriptive data, data availability (data
missingness), and statistical parameters were included. Given no formal
risk of bias tool exists, quality assessment here was not used as a
prerequisite for inclusion/exclusion in the meta-analyses. Rather, it
was used to supplement the meta-analyses and aid interpretation.
## Meta-analysis

To identify studies which could be meta-analysed, a set of
[rules](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/master/figures/meta_analysis_flowchart.pdf)
were used. These rules ensured that the exposure and outcome were
consistent across studies, but also that there was no population overlap
between the outcomes of different studies or between the outcomes and
exposure of different studies. Sample overlap can induce bias in MR
studies. Where there was overlap between the outcome of one study and
the outcome of another study, or where there was overlap between the
exposure of one study and the outcome of another study, the study with
the larger sample size was retained. Excluding studies with overlapping
outcomes or overlapping exposures and outcomes would involve including
non-independent data and result in overly precise estimates. Finally,
studies were excluded based on whether the MR method was comparable and
then on whether the units where compatible with one another (e.g., where
both studies reported a standard deviation increase in BMI). Studies
which had overlapping exposure populations were included as the risk of
bias is low. For completeness, studies were not excluded based on the
quality assessment score, but are discussed later in this chapter when
interpreting the meta-analysis findings. Inclusion and exclusion
information is available as a [text
file](https://github.com/mattlee821/systematic_review_MR_adiposity/blob/master/analysis/meta_analysis/decision_list.txt).

Meta-analysis was performed using the `meta` package in `R` and the
function `metagen()` using an inverse variance weighted random-effects
model using estimates and standard errors. For binary outcomes, the
relevant summary method was used for odds ratios, risk ratios, and
hazard ratios etc. For continuous outcomes, the mean difference was used
for the underlying summary method. For both binary and continuous
outcomes, the Hartung and Knapp method to adjust confidence intervals to
reflect uncertainty in the estimation of between-study heterogeneity was
used. Between study variance was estimated for all meta-analyses using
the Paule-Mandel estimator.

## Narrative synthesis

A narrative synthesis was performed for all articles that were not
included in the meta-analyses. The outcome categories used to categorise
outcomes during data extraction were used to guide the synthesis. The
direction of effect estimates across outcome categories were summarised
across the exposures used for these analyses.
## Author contributions

Matthew A Lee - conceptualization, data curation, formal analysis,
investigation, methodology, project administration, software,
supervision, validation, visualization, writing (original draft
preparation), writing (review & editing)

Charlie Hatcher - data curation, investigation, validation, writing
(review & editing)

Luke J Mcguiness - data curation, methodology, writing (review &
editing)

Nancy McBride - data curation, writing (review & editing)

Thomas Battram - data curation, writing (review & editing)

Wenxin Wang - data curation, writing (review & editing)

Si Fiang - data curation, writing (review & editing)

Kaitlin H Wade - resources, data curation, supervision, writing (review
& editing)

laura J Corbin - resources, supervision, writing (review & editing)

Nicholas J Timpson - resources, supervision, writing (review & editing)

### Screening, data extraction, and analyses

Title and abstract screening - MAL and LJM

Full text screening - MAL and LJM

Data extraction was performed independently by 8 reviewers - MAL, CH,
LJM, NM, TB, WW, SF, KHW

Data extraction was performed a second time, independently by MAL and CH

Analyses - MAL

Writing - MAL
