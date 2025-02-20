**playing around with cadquery**


To install cq-editor:
```bash
$ curl -LO https://github.com/CadQuery/CQ-editor/releases/download/nightly/CQ-editor-master-Linux-x86_64.sh
$ sh CQ-editor-master-Linux-x86_64.sh
$ rm CQ-editor-master-Linux-x86_64.sh
```

To run from command:
```bash
$ $HOME/cq-editor/run.sh # this actually doesn't work so
$ ~/cq-editor/bin/cq-editor &
```


```python
import cadquery
if False:
    result = cadquery.Workplane("XY").box(1, 1, 1).hole(0.15)
if False:
    result = cadquery.Workplane("XY").box(3, 3, 0.5).edges("|Z").fillet(0.125)
if True:
    height = 60.0
    width = 60.0
    thickness = 10.0
    diameter = 10.0
    padding = 12.0
    result = (
        cadquery.Workplane("XY")
        .box(height, width, thickness)
        .faces(">Z")
        .workplane()
        .hole(diameter)
        .faces(">Z")
        .workplane()
        .rect(height - padding, width - padding, forConstruction=True)
        .vertices()
        .cboreHole(2.4, 4.4, 2.1)
        .edges("|Z")
        .fillet(2.0)
    )
if False:
    cadquery.exporters.export(result, "result.stl")
    cadquery.exporters.export(result.section(), "result.dxf")
    cadquery.exporters.export(result, "result.step")
```

```python
import cadquery as cq

# Your model code here
model = cq.Workplane("XY").box(10, 20, 30)

# Export the model to an STL file
cq.exporters.export(model, "output.stl")
```