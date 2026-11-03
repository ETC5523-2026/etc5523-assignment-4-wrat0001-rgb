library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(plotly)
library(victransport)

# Load data bundled with the package
data("patronage", package = "victransport")

# Consistent colours across charts
day_type_colours <- c(
  "Normal Weekday" = "#E97870",
  "School Holiday Weekday" = "#196E69",
  "Weekend" = "#548CC8"
)

day_levels <- c(
  "Normal Weekday",
  "School Holiday Weekday",
  "Weekend"
)

weekday_levels <- c(
  "Monday", "Tuesday", "Wednesday",
  "Thursday", "Friday", "Saturday", "Sunday"
)

# Reusable row for summary cards
summary_row <- function(label, value) {
  div(
    class = "summary-row",
    span(label),
    strong(value)
  )
}

# Reusable key finding box
finding_box <- function(...) {
  div(
    class = "finding-box",
    style = paste(
      "background-color: #F3F8F6 !important;",
      "border-left: 4px solid #176B65 !important;",
      "border-radius: 4px;",
      "padding: 12px 15px;",
      "margin-top: 16px;",
      "margin-bottom: 10px;",
      "color: #586B69;",
      "line-height: 1.5;",
      "width: 100%;"
    ),
    ...
  )
}

# User interface
ui <- page_sidebar(
  title = "Victorian Public Transport Explorer",

  theme = bs_theme(
    version = 5,
    bootswatch = "flatly",
    primary = "#196E69"
  ),

  # Custom styling
  header = tags$head(
    tags$style(HTML("
      body {
        color: #273638;
      }

      .bslib-sidebar-layout > .sidebar {
        background: #F5F8F7;
      }

      .card {
        border: 1px solid #DFE8E5;
        box-shadow: none;
        margin-bottom: 0;
      }

      .card-header {
        background: #F4F8F7;
        color: #234F4B;
        font-weight: 600;
      }

      /* Compact introduction with all text visible */
      .intro-card .card-body {
        padding: 10px 14px !important;
      }

      .intro-card .card-header {
        padding: 8px 14px;
      }

      .intro-card p {
        margin-bottom: 5px;
        line-height: 1.4;
        font-size: 0.98rem;
        white-space: normal;
      }

      .intro-card p:last-child {
        margin-bottom: 0;
      }

      /* Apply font size to the actual Shiny output, not only its wrapper */
      .summary-card .summary-number,
      .summary-card .summary-number #mean_patronage,
      .summary-card .summary-number #months_shown,
      .summary-card .summary-number .shiny-text-output {
        font-size: 2.8rem !important;
        font-weight: 750 !important;
        line-height: 1.15 !important;
        color: #176B65 !important;
      }

      .summary-card .summary-number {
        margin: 2px 0 8px;
        font-size: 2.8rem !important;
      }
      #mean_patronage, #months_shown {
        font-size: 2.8rem !important;
        font-weight: 750 !important;
        color: #176B65 !important;
        line-height: 1.15 !important;
      }

      .summary-card .card-body {
        padding: 10px 14px;
      }

      .summary-details {
        border-top: 1px solid #DFE8E5;
        padding-top: 8px;
      }

      .summary-details summary {
        cursor: pointer;
        color: #176B65;
        font-weight: 600;
      }

      .summary-details summary:hover {
        text-decoration: underline;
      }

      .summary-details[open] summary {
        margin-bottom: 8px;
      }

      .summary-row {
        display: flex;
        justify-content: space-between;
        align-items: baseline;
        gap: 12px;
        padding: 6px 0;
        border-bottom: 1px solid #E9EEEE;
      }

      .summary-row strong {
        text-align: right;
      }

      .chart-explanation {
        color: #586B69;
        font-size: 0.92rem;
        margin-top: 12px;
        line-height: 1.5;
      }

      /* Consistent pale-green key-finding callouts for all three tabs */
      .finding-box {
        display: block;
        background-color: #F3F8F6 !important;
        border-left: 3px solid #176B65 !important;
        border-radius: 4px;
        padding: 12px 14px;
        margin-top: 16px;
        color: #586B69;
        font-size: 0.95rem;
        line-height: 1.5;
        width: 100%;
      }

      .finding-box > strong {
        display: block;
        margin-bottom: 8px;
      }

      .finding-box p {
        margin-bottom: 8px;
      }

      .finding-box p:last-child {
        margin-bottom: 0;
      }

      .finding-box strong {
        font-weight: 700;
      }

      .nav-tabs .nav-link {
        font-weight: 500;
      }

      /* Let content grow rather than clip */
      .intro-card,
      .summary-card,
      .charts-card {
        height: auto !important;
        min-height: 0 !important;
        max-height: none !important;
        overflow: visible !important;
      }

      .intro-card .card-body,
      .summary-card .card-body,
      .charts-card .card-body,
      .charts-card .tab-content,
      .charts-card .tab-pane {
        height: auto !important;
        min-height: 0 !important;
        max-height: none !important;
        overflow: visible !important;
      }

      .charts-card .html-widget {
        flex-shrink: 0 !important;
      }

      #trend_plot,
      #weekday_plot {
        height: 480px !important;
        min-height: 480px !important;
      }

      #mode_plot {
        height: 450px !important;
        min-height: 450px !important;
      }

      /* Compact spacing above charts */
      .summary-section {
        margin-bottom: 12px;
      }

      .charts-card {
        margin-top: 0;
      }
    "))
  ),

  sidebar = sidebar(
    title = "Explore patronage",
    width = 280,

    checkboxGroupInput(
      inputId = "mode",
      label = "Transport mode",
      choices = sort(unique(patronage$mode)),
      selected = sort(unique(patronage$mode))
    ),

    checkboxGroupInput(
      inputId = "day_type",
      label = "Day type",
      choices = day_levels,
      selected = day_levels
    ),

    sliderInput(
      inputId = "years",
      label = "Reporting years",
      min = min(patronage$year),
      max = max(patronage$year),
      value = range(patronage$year),
      step = 1,
      sep = ""
    ),

    sliderInput(
      inputId = "months",
      label = "Reporting months",
      min = 1,
      max = 12,
      value = c(1, 12),
      step = 1
    ),

    textOutput("selected_months"),

    br(),

    helpText(
      "The summary figure is the unweighted mean of selected",
      "reported daily averages, not total passenger journeys",
      "or combined network-wide daily patronage."
    ),

    hr(),

    h5("How to use the filters"),

    p(
      "Tick or untick transport modes and day types",
      "to include or exclude them."
    ),

    p(
      "Use the year slider to choose the reporting years."
    ),

    p(
      strong("Reporting months: "),
      "Select a range of calendar months. The same month range ",
      "applies to every selected year. For example, selecting ",
      "May–December and 2020–2026 includes those months in ",
      "each year where data is available."
    ),

    p(
      "Charts, summary figures and key findings",
      "update automatically when the filters change."
    )
  ),

  # Introduction: keep above the summary cards and fully visible
  div(
    class = "card intro-card",
    style = "margin-bottom: 12px !important; height: auto !important; overflow: visible !important;",
    div(
      class = "card-header",
      "Exploring public transport patronage in Victoria"
    ),
    div(
      class = "card-body",
      p("Designed for Victorian public transport users and anyone interested in transport trends."),
      p(
        strong("Key question: "),
        "How does average daily public transport patronage differ across transport modes, days of the week and day types in Victoria, and how has patronage changed between 2018 and 2026?"
      )
    )
  ),

  # Summary cards
  div(
    class = "summary-section",

    layout_columns(
      card(
        class = "summary-card",

        card_header("Mean reported daily patronage"),

        card_body(
          div(
            class = "summary-number",
            style = "font-size: 2.8rem; font-weight: 750; color: #176B65;",
            textOutput("mean_patronage", inline = TRUE)
          ),

          tags$details(
            class = "summary-details",
            tags$summary("By transport mode"),
            uiOutput("mode_breakdown")
          )
        )
      ),

      card(
        class = "summary-card",

        card_header("Reporting months"),

        card_body(
          div(
            class = "summary-number",
            style = "font-size: 2.8rem; font-weight: 750; color: #176B65;",
            textOutput("months_shown", inline = TRUE)
          ),

          tags$details(
            class = "summary-details",
            tags$summary("Reporting period"),
            uiOutput("reporting_period")
          )
        )
      ),

      col_widths = c(6, 6)
    )
  ),

  # Charts
div(
  class = "charts-card",

  navset_card_tab(
    id = "chart_tabs",

    nav_panel(
      "Trend over time",

      plotlyOutput(
        "trend_plot",
        height = "480px"
      ),

      p(
        class = "chart-explanation",
        "Each line represents the unweighted mean of",
        "reported daily averages for a day type within",
        "each reporting month. Hover over the lines",
        "to view the values."
      ),

      uiOutput("trend_finding")
    ),

    nav_panel(
      "Day-of-week comparison",

      plotlyOutput(
        "weekday_plot",
        height = "480px"
      ),

      p(
        class = "chart-explanation",
        "Bars show the unweighted mean of reported daily",
        "averages for each day of the week and day type.",
        "Normal weekdays and school holiday weekdays",
        "can be compared side by side, while weekend",
        "observations appear on Saturday and Sunday.",
        "Hover over the bars to see the values."
      ),

      uiOutput("weekday_finding")
    ),

    nav_panel(
      "Compare transport modes",

      plotlyOutput(
        "mode_plot",
        height = "450px"
      ),

      p(
        class = "chart-explanation",
        "Bars compare the mean of reported daily averages",
        "for the selected transport modes, day types and",
        "reporting period. These values are not total",
        "passenger journeys."
      ),

      uiOutput("mode_finding")
    )
  )
)

) # Close page_sidebar()

# Server
server <- function(input, output, session) {

  # Shared filtered data
  filtered_data <- reactive({

    validate(
      need(
        length(input$mode) > 0,
        "Please select at least one transport mode."
      ),
      need(
        length(input$day_type) > 0,
        "Please select at least one day type."
      )
    )

    data <- patronage |>
      filter(
        mode %in% input$mode,
        day_type %in% input$day_type,
        year >= input$years[1],
        year <= input$years[2],
        month >= input$months[1],
        month <= input$months[2]
      )

    validate(
      need(
        nrow(data) > 0,
        "No observations match your filters. Try a wider period."
      )
    )

    data
  })

  # Summary by transport mode
  mode_summary <- reactive({

    filtered_data() |>
      group_by(mode) |>
      summarise(
        mean_patronage = mean(
          avg_daily_patronage,
          na.rm = TRUE
        ),
        .groups = "drop"
      )
  })

  # Use exported package function
  weekday_summary <- reactive({
    summarise_daily_patronage(
      data = filtered_data()
    )
  })

  # Selected month range
  output$selected_months <- renderText({
    paste0(
      month.abb[input$months[1]],
      " – ",
      month.abb[input$months[2]]
    )
  })

  # Overall mean
  output$mean_patronage <- renderText({

    data <- filtered_data()

    scales::comma(
      round(mean(
        data$avg_daily_patronage,
        na.rm = TRUE
      ))
    )
  })

  # Transport mode breakdown
  output$mode_breakdown <- renderUI({

    data <- mode_summary()

    tagList(
      lapply(seq_len(nrow(data)), function(i) {
        summary_row(
          data$mode[i],
          scales::comma(
            round(data$mean_patronage[i])
          )
        )
      })
    )
  })

  # Reporting months
  output$months_shown <- renderText({

    data <- filtered_data()

    dplyr::n_distinct(data$date)
  })

  # Reporting period
  output$reporting_period <- renderUI({

    filtered_data()

    selected_years <- paste(
      input$years[1],
      input$years[2],
      sep = "–"
    )

    selected_months <- paste0(
      month.abb[input$months[1]],
      " – ",
      month.abb[input$months[2]]
    )

    tagList(
      summary_row("Years", selected_years),
      summary_row("Months", selected_months)
    )
  })

  # Monthly trend data
  monthly_summary <- reactive({

    filtered_data() |>
      group_by(date, day_type) |>
      summarise(
        mean_patronage = mean(
          avg_daily_patronage,
          na.rm = TRUE
        ),
        .groups = "drop"
      )
  })

  # Interactive trend chart
  output$trend_plot <- renderPlotly({

    monthly <- monthly_summary() |>
      mutate(
        hover_text = paste0(
          "Reporting month: ",
          format(date, "%B %Y"),
          "<br>Day type: ", day_type,
          "<br>Mean daily patronage: ",
          scales::comma(round(mean_patronage))
        )
      )

    p <- ggplot(
      monthly,
      aes(
        x = date,
        y = mean_patronage,
        colour = day_type,
        group = day_type,
        text = hover_text
      )
    ) +
      geom_line(linewidth = 0.95) +
      geom_point(
        size = 1,
        alpha = 0.5
      ) +
      scale_colour_manual(
        values = day_type_colours,
        breaks = day_levels,
        drop = TRUE
      ) +
      scale_y_continuous(
        labels = scales::label_comma()
      ) +
      labs(
        title = "Average daily patronage over time",
        x = "Reporting month",
        y = "Mean reported daily patronage",
        colour = "Day type"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.title = element_text(
          face = "bold",
          size = 15,
          colour = "#273638"
        ),
        panel.grid.minor = element_blank(),
        legend.position = "right"
      )

    ggplotly(
      p,
      tooltip = "text"
    ) |>
      layout(
        hovermode = "closest",
        autosize = TRUE,
        margin = list(
          l = 85,
          r = 20,
          b = 70,
          t = 65
        )
      ) |>
      config(
        displaylogo = FALSE,
        responsive = TRUE
      )
  })

  # Dynamic trend findings
output$trend_finding <- renderUI({

  data <- monthly_summary()

  findings <- list()

  # 1. Compare the first and last available years selected by the user.
  # Note: boundary years may contain only some reporting months.
  annual <- data |>
    mutate(year = as.integer(format(date, "%Y"))) |>
    group_by(year) |>
    summarise(
      mean_patronage = mean(mean_patronage, na.rm = TRUE),
      .groups = "drop"
    ) |>
    arrange(year)

  if (nrow(annual) >= 2) {
    first_year <- annual$year[1]
    last_year <- annual$year[nrow(annual)]
    before <- annual$mean_patronage[1]
    after <- annual$mean_patronage[nrow(annual)]

    if (is.finite(before) && is.finite(after) && before > 0) {
      pct <- 100 * abs(after - before) / before
      direction <- if (after >= before) "higher" else "lower"

      findings <- append(findings, list(
        p(
          strong(paste0(first_year, " vs ", last_year, ": ")),
          "Mean reported daily patronage was ",
          scales::comma(round(before)), " in ", first_year,
          ", compared with ", scales::comma(round(after)),
          " in ", last_year, " (",
          round(pct, 1), "% ", direction, " in ", last_year,
          "). These are averages for the available selected months,",
          " so boundary years may be incomplete."
        )
      ))
    }
  }

  # 2. Weekdays vs weekends (same method as the day-of-week tab)
  week_data <- weekday_plot_data() |>
    filter(is.finite(mean_daily_patronage))

  weekdays <- week_data |>
    filter(day_type %in% c("Normal Weekday", "School Holiday Weekday"))
  weekends <- week_data |>
    filter(day_type == "Weekend")

  if (nrow(weekdays) > 0 && nrow(weekends) > 0) {
    weekday_mean <- mean(weekdays$mean_daily_patronage)
    weekend_mean <- mean(weekends$mean_daily_patronage)

    if (is.finite(weekday_mean) && is.finite(weekend_mean) &&
        weekend_mean > 0) {
      pct <- 100 * abs(weekday_mean - weekend_mean) / weekend_mean
      direction <- if (weekday_mean >= weekend_mean) "higher" else "lower"

      findings <- append(findings, list(
        p(
          strong("Weekdays vs weekends: "),
          "Average reported daily patronage is ",
          scales::comma(round(weekday_mean)),
          " on weekdays, compared with ",
          scales::comma(round(weekend_mean)),
          " on weekends (", round(pct, 1), "% ", direction,
          " on weekdays)."
        )
      ))
    }
  }

  # 3. Normal vs school holiday weekdays
  normal <- data |>
    filter(day_type == "Normal Weekday") |>
    select(date, normal_value = mean_patronage)

  holiday <- data |>
    filter(day_type == "School Holiday Weekday") |>
    select(date, holiday_value = mean_patronage)

  comparable <- inner_join(normal, holiday, by = "date")

  if (nrow(comparable) > 0) {

    normal_mean <- mean(comparable$normal_value)
    holiday_mean <- mean(comparable$holiday_value)

    pct <- 100 * abs(normal_mean - holiday_mean) / holiday_mean

    direction <- if (normal_mean >= holiday_mean) {
      "higher"
    } else {
      "lower"
    }

    findings <- append(
      findings,
      list(
        p(
          strong("Normal vs school holiday weekdays: "),
          "Across ", nrow(comparable),
          " comparable reporting months, normal weekdays",
          " averaged ",
          scales::comma(round(normal_mean)),
          ", compared with ",
          scales::comma(round(holiday_mean)),
          " during school holidays (",
          round(pct, 1),
          "% ", direction, ")."
        )
      )
    )
  }

  validate(
    need(
      length(findings) > 0,
      "Select more reporting periods or day types to see comparisons."
    )
  )

  finding_box(
    strong("Key findings"),
    tagList(findings)
  )
})

  # Day-of-week data
weekday_plot_data <- reactive({

  # Use the exported package summary function.
  # Weight mode-level means by their observation counts so
  # the result matches the mean of the original filtered rows.
  weekday_summary() |>
    group_by(day_of_week, day_type) |>
    summarise(
      mean_daily_patronage = weighted.mean(
        mean_daily_patronage,
        w = n_observations,
        na.rm = TRUE
      ),
      .groups = "drop"
    ) |>
    mutate(
      day_of_week = factor(
        day_of_week,
        levels = weekday_levels
      ),
      day_type = factor(
        day_type,
        levels = day_levels
      )
    )
})

  # Interactive weekday chart
  output$weekday_plot <- renderPlotly({

    weekday_data <- weekday_plot_data() |>
      mutate(
        hover_text = paste0(
          "Day: ", day_of_week,
          "<br>Day type: ", day_type,
          "<br>Mean daily patronage: ",
          scales::comma(round(mean_daily_patronage))
        )
      )

    p <- ggplot(
      weekday_data,
      aes(
        x = day_of_week,
        y = mean_daily_patronage,
        fill = day_type,
        text = hover_text
      )
    ) +
      geom_col(
        position = position_dodge(width = 0.78),
        width = 0.70
      ) +
      scale_fill_manual(
        values = day_type_colours,
        breaks = day_levels,
        drop = TRUE
      ) +
      scale_y_continuous(
        labels = scales::label_comma(),
        expand = expansion(mult = c(0, 0.08))
      ) +
      labs(
        title = "How does patronage vary across the week?",
        x = "Day of the week",
        y = "Mean reported daily patronage",
        fill = "Day type"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.title = element_text(
          face = "bold",
          size = 15,
          colour = "#273638"
        ),
        axis.text.x = element_text(
          angle = 30,
          hjust = 1
        ),
        panel.grid.minor = element_blank(),
        legend.position = "right"
      )

    ggplotly(
      p,
      tooltip = "text"
    ) |>
      layout(
        hovermode = "closest",
        autosize = TRUE,
        legend = list(
          title = list(text = "Day type"),
          orientation = "v",
          x = 1.02,
          xanchor = "left",
          y = 1,
          yanchor = "top"
        ),
        margin = list(
          l = 90,
          r = 175,
          t = 70,
          b = 90
        )
      ) |>
      config(
        displaylogo = FALSE,
        responsive = TRUE
      )
  })

  # Dynamic weekday findings
  output$weekday_finding <- renderUI({

    data <- weekday_plot_data() |>
      filter(!is.na(mean_daily_patronage))

    # Weekdays vs weekends
    weekday_values <- data |>
      filter(
        day_type %in% c(
          "Normal Weekday",
          "School Holiday Weekday"
        )
      )

    weekend_values <- data |>
      filter(day_type == "Weekend")

    # Normal vs school holiday weekdays
    normal <- data |>
      filter(day_type == "Normal Weekday") |>
      select(
        day_of_week,
        normal_value = mean_daily_patronage
      )

    holiday <- data |>
      filter(day_type == "School Holiday Weekday") |>
      select(
        day_of_week,
        holiday_value = mean_daily_patronage
      )

    comparable <- inner_join(
      normal,
      holiday,
      by = "day_of_week"
    )

    findings <- list()

    if (
      nrow(weekday_values) > 0 &&
      nrow(weekend_values) > 0
    ) {

      weekday_mean <- mean(
        weekday_values$mean_daily_patronage
      )

      weekend_mean <- mean(
        weekend_values$mean_daily_patronage
      )

      pct <- if (weekend_mean > 0) {
        100 * abs(weekday_mean - weekend_mean) /
          weekend_mean
      } else {
        NA_real_
      }

      direction <- if (weekday_mean >= weekend_mean) {
        "higher"
      } else {
        "lower"
      }

      findings <- append(
        findings,
        list(
          p(
            strong("Weekdays vs weekends: "),
            "Average reported daily patronage is ",
            scales::comma(round(weekday_mean)),
            " on weekdays, compared with ",
            scales::comma(round(weekend_mean)),
            " on weekends (",
            round(pct, 1),
            "% ", direction, " on weekdays)."
          )
        )
      )
    }

    if (nrow(comparable) > 0) {

      normal_mean <- mean(comparable$normal_value)
      holiday_mean <- mean(comparable$holiday_value)

      pct <- if (holiday_mean > 0) {
        100 * abs(normal_mean - holiday_mean) /
          holiday_mean
      } else {
        NA_real_
      }

      direction <- if (normal_mean >= holiday_mean) {
        "higher"
      } else {
        "lower"
      }

      findings <- append(
        findings,
        list(
          p(
            strong("Normal vs school holiday weekdays: "),
            "Across ", nrow(comparable),
            " comparable weekdays, normal weekdays",
            " average ",
            scales::comma(round(normal_mean)),
            ", compared with ",
            scales::comma(round(holiday_mean)),
            " during school holidays (",
            round(pct, 1),
            "% ", direction, ")."
          )
        )
      )
    }

    validate(
      need(
        length(findings) > 0,
        "Select more day types to compare weekday patterns."
      )
    )

    finding_box(
      strong("Key findings"),
      tagList(findings)
    )
  })

  # Interactive transport mode chart
  output$mode_plot <- renderPlotly({

    plot_data <- mode_summary() |>
      arrange(mean_patronage) |>
      mutate(
        mode = factor(mode, levels = mode),
        hover_text = paste0(
          "Transport mode: ", mode,
          "<br>Mean daily patronage: ",
          scales::comma(round(mean_patronage))
        )
      )

    p <- ggplot(
      plot_data,
      aes(
        x = mode,
        y = mean_patronage,
        text = hover_text
      )
    ) +
      geom_col(
        fill = "#196E69",
        width = 0.65
      ) +
      geom_text(
        aes(label = scales::comma(round(mean_patronage))),
        hjust = -0.12,
        size = 3.8,
        colour = "#273638",
        show.legend = FALSE
      ) +
      coord_flip() +
      scale_y_continuous(
        labels = scales::label_comma(),
        expand = expansion(mult = c(0, 0.18))
      ) +
      labs(
        title = "Average daily patronage by transport mode",
        subtitle = "Unweighted mean of reported daily averages",
        x = NULL,
        y = "Mean reported daily patronage"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.title = element_text(
          face = "bold",
          size = 15,
          colour = "#273638"
        ),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank()
      )

    ggplotly(
      p,
      tooltip = "text"
    ) |>
      layout(
        hovermode = "closest",
        showlegend = FALSE,
        autosize = TRUE,
        margin = list(
          l = 135,
          r = 40,
          t = 80,
          b = 70
        )
      ) |>
      config(
        displaylogo = FALSE,
        responsive = TRUE
      )
  })

  # Dynamic transport mode finding
  output$mode_finding <- renderUI({

    data <- mode_summary() |>
      arrange(desc(mean_patronage))

    validate(
      need(
        nrow(data) > 0,
        "No transport modes available."
      )
    )

    if (nrow(data) == 1) {
      return(
        finding_box(
          p(
            strong("Key finding: "),
            data$mode[1],
            " has a mean reported daily patronage of ",
            scales::comma(round(data$mean_patronage[1])),
            " for the selected period."
          )
        )
      )
    }

    highest <- data[1, ]
    lowest <- data[nrow(data), ]

    finding_box(
      p(
        strong("Key finding: "),
        highest$mode,
        " has the highest mean reported daily patronage",
        " among the selected modes (",
        scales::comma(round(highest$mean_patronage)),
        "), while ",
        lowest$mode,
        " has the lowest (",
        scales::comma(round(lowest$mean_patronage)),
        ")."
      )
    )
  })
}

shinyApp(ui, server)
