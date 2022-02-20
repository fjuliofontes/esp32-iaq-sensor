import datetime, requests, json, dash, plotly
import dash_core_components as dcc
import dash_html_components as html
import plotly.graph_objects as go
from dash.dependencies import Input, Output
from plotly import subplots

FIR_FILTER_ORDER = 2

def get_sample(nr_of_sample):
    
    base_url = "https://endpoint.firebasedatabase.app/filename.json?orderBy=\"$key\"&limitToLast=" + str(int(nr_of_sample))
    res = requests.get(base_url)

    if res.status_code == 200:
        received_data = json.loads(res.text)

        for key in received_data:
                return received_data[key]

    return {}


def get_last_samples(nr_of_samples):
    data = []

    base_url = "https://endpoint.firebasedatabase.app/filename.json?orderBy=\"$key\"&limitToLast=" + str(int(nr_of_samples+FIR_FILTER_ORDER+1))
    res = requests.get(base_url)

    if res.status_code == 200:
        received_data = json.loads(res.text)

        # receive data
        for key in received_data:
            data.append(received_data[key])

        # organize by timestamp
        for i in range(0,len(data)-1):
            for j in range(i+1,len(data)):
                if data[j]["timestamp"] < data[i]["timestamp"]:
                    bck = data[i]
                    data[i] = data[j]
                    data[j] = bck
        
        # filter data
        # SUM b(k+1) x(n-k)    for 1<=n<=length(x)
        # 0.045690   0.454310   0.454310   0.045690
        b = [0.068009, 0.863982, 0.068009]
        for i in range(FIR_FILTER_ORDER,len(data)):
            data[i]["t"] = data[i]["t"]*b[0] + data[i-1]["t"]* b[1] + data[i-2]["t"]* b[2]
            data[i]["h"] = data[i]["h"]*b[0] + data[i-1]["h"]* b[1] + data[i-2]["h"]* b[2]
            data[i]["p"] = data[i]["p"]*b[0] + data[i-1]["p"]* b[1] + data[i-2]["p"]* b[2]
            data[i]["iaq"] = data[i]["iaq"]*b[0] + data[i-1]["iaq"]* b[1] + data[i-2]["iaq"]* b[2]
            data[i]["eco2"] = data[i]["eco2"]*b[0] + data[i-1]["eco2"]* b[1] + data[i-2]["eco2"]* b[2]
            data[i]["evoc"] = data[i]["evoc"]*b[0] + data[i-1]["evoc"]* b[1] + data[i-2]["evoc"]* b[2]

        if len(data) == int(nr_of_samples+FIR_FILTER_ORDER+1):
            exceedingSamples = int(FIR_FILTER_ORDER + 1)
            data = data[exceedingSamples:]

    return data
            

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

server = app.server

app.layout = html.Div(
    html.Div([
        html.H4('Indoor Air Quality (BME680 based)'),
        #html.Div(id='live-update-text'),
        dcc.Graph(id='gauge-indicators'),
        dcc.Graph(id='live-update-graph'),
        dcc.Interval(
            id='interval-component',
            interval= 5*60*1000, # every 5 minutes
            n_intervals=0
        )
    ])
)

# Multiple components can update everytime interval gets fired.
@app.callback(Output('live-update-graph', 'figure'),
              Input('interval-component', 'n_intervals'))
def update_graph_live(n):
    data = {
        'time': [],
        'T': [],
        'H': [],
        'P': [],
        'IAQ' :  [],
        'eCO2' : [],
        'eVOC' : [],
        'a' : []
    }

    # Collect some data
    rows = get_last_samples(24 * 60 * 60 / 300)

    for row in rows:
        data['time'].append(datetime.datetime.fromtimestamp(int(row["timestamp"])))
        data['T'].append(float(row["t"]))
        data['H'].append(float(row["h"]))
        data['P'].append(float(row["p"])/100)
        data['IAQ'].append(float(row["iaq"]))
        data['eCO2'].append(float(row["eco2"]))
        data['eVOC'].append(float(row["evoc"]))
        data['a'].append(int(row["a"]))

    # if len(data['T']) > 0:
    #     tempRangeMin = int( min(data['T']) - 5 )
    #     tempRangeMax = int( max(data['T']) + 5 )
    # else: 
    #     tempRangeMin = 0
    #     tempRangeMax = 30

    # if len(data['H']) > 0:
    #     humiRangeMin = int( min(data['H']) - 5 )
    #     humiRangeMax = int( max(data['H']) + 5 )
    # else: 
    #     humiRangeMin = 0
    #     humiRangeMax = 100
    
    # if len(data['P']) > 0:
    #     pressRangeMin = int( min(data['P']) - 10 )
    #     pressRangeMax = int( max(data['P']) + 10 )
    # else: 
    #     pressRangeMin = 500
    #     pressRangeMin = 5000

    # Create the graph with subplots
    fig = plotly.subplots.make_subplots(
        subplot_titles=(
            "Temperature", 
            "Humidity",
            "Pressure", 
            "IAQ index",
            "Equivalent CO2",
            "Equivalent VOC"
        ),
        rows=6, 
        cols=1,
        vertical_spacing=0.05)
    
    fig.append_trace(
        {
            'x': data['time'],
            'y': data['T'],
            'name': 'Temperature',
            'mode': 'lines',
            'type': 'scatter'
        },
        row=1, 
        col=1
    )

    fig.append_trace(
        {
            'x': data['time'],
            'y': data['H'],
            'name': 'Humidity',
            'mode': 'lines',
            'type': 'scatter'
        }, 
        row=2, 
        col=1
    )

    fig.append_trace(
        {
            'x': data['time'],
            'y': data['P'],
            'name': 'Pressure',
            'mode': 'lines',
            'type': 'scatter'
        }, 
        row=3, 
        col=1
    )

    fig.append_trace(
        {
            'x': data['time'],
            'y': data['IAQ'],
            'name': 'IAQ',
            'mode': 'lines',
            'type': 'scatter'
        },
        row=4, 
        col=1
    )

    fig.append_trace(
        {
            'x': data['time'],
            'y': data['eCO2'],
            'name': 'eCO2',
            'mode': 'lines', # + markers
            'type': 'scatter'
        }, 
        row=5, 
        col=1
    )

    fig.append_trace(
        {
            'x': data['time'],
            'y': data['eVOC'],
            #'text': data['time'],
            'name': 'eVOC',
            'mode': 'lines',
            'type': 'scatter'
        }, 
        row=6, 
        col=1
    )

    # Update xaxis properties
    fig.update_xaxes(title_text="Time (HH:MM:SS)", row=1, col=1)
    fig.update_xaxes(title_text="Time (HH:MM:SS)", row=2, col=1)
    fig.update_xaxes(title_text="Time (HH:MM:SS)", row=3, col=1)
    fig.update_xaxes(title_text="Time (HH:MM:SS)", row=4, col=1)
    fig.update_xaxes(title_text="Time (HH:MM:SS)", row=5, col=1)
    fig.update_xaxes(title_text="Time (HH:MM:SS)", row=6, col=1)

    # Update yaxis properties
    # fig.update_yaxes(title_text="Celsius", row=1, col=1, range = [tempRangeMin, tempRangeMax] )
    fig.update_yaxes(title_text="Celsius", row=1, col=1)
    # fig.update_yaxes(title_text="Percentage", row=2, col=1, range = [humiRangeMin, humiRangeMax])
    fig.update_yaxes(title_text="Percentage", row=2, col=1)
    # fig.update_yaxes(title_text="hPascal", row=3, col=1, range = [pressRangeMin,pressRangeMax])
    fig.update_yaxes(title_text="hPascal", row=3, col=1)
    fig.update_yaxes(title_text="Index", row=4, col=1)
    fig.update_yaxes(title_text="PPM", row=5, col=1)
    fig.update_yaxes(title_text="PPM", row=6, col=1)

    fig.update_layout(
        height=2000, 
        width=None, 
        title_text="Graphical Visualization",
        showlegend=True
    )

    return fig

# Multiple components can update everytime interval gets fired.
@app.callback(Output('gauge-indicators', 'figure'),
              Input('interval-component', 'n_intervals'))
def update_graph_live(n):
    current = get_sample(1)
    last = get_sample(2)

    fig = go.Figure()

    fig.add_trace(
        go.Indicator(
            domain = {'row': 0, 'column': 1},
            value = float(current["iaq"]),
            mode = "gauge+number+delta",
            title = {'text': "IAQ",'font': {'size': 24}},
            delta = {
                'reference': float(last["iaq"]),
                'increasing': {'color': "red"},
                'decreasing': {'color': "green"}
            },
            gauge = {
                'axis': {
                    'range': [0, 351],
                    'tickwidth': 1, 
                    'tickcolor': "darkblue"
                },
                'borderwidth': 2,
                'bordercolor': "gray",
                'bar': {'color': "green"},
                'steps' : [
                    {'range': [0, 50], 'color': "#00e400"},
                    {'range': [51, 100], 'color': "#92d050"},
                    {'range': [101, 150], 'color': "#ffff02"},
                    {'range': [151, 200], 'color': "#ff7e00"},
                    {'range': [201, 250], 'color': "#ff0000"},
                    {'range': [251, 350], 'color': "#99004c"},
                    {'range': [351, None], 'color': "#663300"}
                ],
                'threshold' : {
                    'line': {'color': "red", 'width': 4}, 'thickness': 0.9, 'value': 175}
                }
        )
    )

    fig.add_trace(
        go.Indicator(
            domain = {'row': 0, 'column': 0},
            value = float(current["t"]),
            mode = "gauge+number+delta",
            title = {'text': "Temperature",'font': {'size': 24}},
            delta = {
                'reference': float(last["t"]),
                'increasing': {'color': "green"},
                'decreasing': {'color': "red"}
            },
            gauge = {
                'axis': {
                    'range': [0, 30],
                    'tickwidth': 1, 
                    'tickcolor': "darkblue"
                },
                'borderwidth': 2,
                'bordercolor': "gray",
                'bar': {'color': "green"},
                'steps' : [
                    {'range': [0, 10], 'color': "#ff0000"},
                    {'range': [10.1, 15], 'color': "#ffff02"},
                    {'range': [15.1, 25], 'color': "#00e400"},
                    {'range': [25.1, 30], 'color': "#ff7e00"}
                ]
            }
        )
    )

    fig.add_trace(
        go.Indicator(
            domain = {'row': 0, 'column': 2},
            value = float(current["h"]),
            mode = "gauge+number+delta",
            title = {'text': "Humidity",'font': {'size': 24}},
            delta = {
                'reference': float(last["h"]),
                'increasing': {'color': "red"},
                'decreasing': {'color': "green"}
            },
            gauge = {
                'axis': {
                    'range': [0, 100],
                    'tickwidth': 1, 
                    'tickcolor': "darkblue"
                },
                'borderwidth': 2,
                'bordercolor': "gray",
                'bar': {'color': "blue"},
                'steps' : [
                    {'range': [0, 25], 'color': "#99f4ff"},
                    {'range': [25.1, 50], 'color': "#7cdffd"},
                    {'range': [50.1, 75], 'color': "#5bcff7"},
                    {'range': [75.1, 100], 'color': "#46b1ef"}
                ]
            }
        )
    )

    fig.update_layout(
        grid = {'rows': 1, 'columns': 3, 'pattern': "independent"}
    )

    return fig

if __name__ == '__main__':
    app.run_server()